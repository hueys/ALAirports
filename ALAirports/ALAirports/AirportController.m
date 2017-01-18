//
//  AirportController.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import "AirportController.h"

@import CoreLocation;
@import CoreSpotlight;
@import MobileCoreServices;
@import UIKit;

#import "Airport.h"

#define kMaxAirportsToLoad 20

NSString* const kAirportCSVFilename = @"airports.csv";

typedef NS_ENUM(NSUInteger, ImportColumnDefinition) {
   kColumnId = 0,
   kColumnIdent,
   kColumnType,
   kColumnName,
   kColumnLatitude,
   kColumnLongitude,
   kColumnElevation,
   kColumnContinent,
   kColumnCountry,
   kColumnRegion,
   kColumnMunicipality,
   kColumnScheduledService,
   kColumnGPSCode,
   kColumnIATACode,
   kColumnLocalCode,
   kColumnHomeLink,
   kColumnWikipediaLink,
   kColumnKeywords,
   kExpectedNumberOfColumns
};

@interface ALAirportController ()
@property (nonatomic) NSMutableArray* airportData;

- (void)loadAirportData;
- (void)indexAirportData;
- (NSString*)stripQuotes:(NSString*)quotedString;
- (AirportType)airportTypeValue:(NSString*)value;
@end

@implementation ALAirportController
#pragma mark - Singleton
+ (instancetype)defaultController
{
   static dispatch_once_t onceToken;
   static ALAirportController* defaultController;
   
   dispatch_once(&onceToken, ^{
      defaultController = [[self alloc] init];
      defaultController.airportData = [[NSMutableArray alloc] initWithCapacity:0];
   });
   
   return defaultController;
}

#pragma mark - Properties
- (NSArray *)airports
{
   if (0 == [self.airportData count])
   {
      [self loadAirportData];
      [self indexAirportData];
   }
   
   return [NSArray arrayWithArray:self.airportData];
}

#pragma mark - ALAirportController
- (ALAirport*)airportWithIdentifier:(NSString*)identifier
{
   NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"airportIdentifier", identifier];
   
   return [self.airports filteredArrayUsingPredicate:predicate].firstObject;
}

#pragma mark - Internal
- (void)loadAirportData
{
   NSURL* csvDataURL = [[NSBundle mainBundle] URLForResource:[kAirportCSVFilename stringByDeletingPathExtension]
                                               withExtension:[kAirportCSVFilename pathExtension]];
   
   NSError* error;
   NSString* csvData = [NSString stringWithContentsOfURL:csvDataURL
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
   
   if (csvData)
   {
      __block NSUInteger index = 0;
      [csvData enumerateLinesUsingBlock:^(NSString* line, BOOL* stop) {
         if (index != 0)
         {
            NSArray* components = [line componentsSeparatedByString:@","];
            
            if (kExpectedNumberOfColumns == [components count])
            {
               if ([components[kColumnCountry] isEqualToString:@"\"US\""])
               {
                  NSUInteger airportIdentifier = (NSUInteger)[components[kColumnId] integerValue];
                  NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithCapacity:0];
                  
                  attributes[kAirportAttributeIdentifier] = [self stripQuotes:components[kColumnIdent]];
                  attributes[kAirportAttributeName] = [self stripQuotes:components[kColumnName]];
                  attributes[kAirportAttributeElevation] = @([components[kColumnElevation] integerValue]);
                  attributes[kAirportAttributeISOCountry] = [self stripQuotes:components[kColumnCountry]];
                  attributes[kAirportAttributeISORegion] = [self stripQuotes:components[kColumnRegion]];
                  attributes[kAirportAttributeMunicipality] = [self stripQuotes:components[kColumnMunicipality]];
                  attributes[kAirportAttributeGPSCode] = [self stripQuotes:components[kColumnGPSCode]];
                  attributes[kAirportAttributeIATACode] = [self stripQuotes:components[kColumnIATACode]];
                  attributes[kAirportAttributeLocalCode] = [self stripQuotes:components[kColumnLocalCode]];
                  attributes[kAirportAttributeHomepageURL] = [self stripQuotes:components[kColumnHomeLink]];
                  attributes[kAirportAttributeWikipediaURL] = [self stripQuotes:components[kColumnWikipediaLink]];
                  attributes[kAirportAttributeScheduledService] = @([components[kColumnScheduledService] isEqualToString:@"yes"]);
                  
                  // Location
                  CLLocation* location = [[CLLocation alloc] initWithLatitude:[components[kColumnLatitude] doubleValue]
                                                                    longitude:[components[kColumnLongitude] doubleValue]];
                  
                  if (location)
                  {
                     attributes[kAirportAttributeLocation] = location;
                  }
                  
                  // Airport Type
                  attributes[kAirportAttributeAirportType] = @([self airportTypeValue:[self stripQuotes:components[kColumnType]]]);
                  
                  // Create the ALAirport instance and add it to the collection of airports
                  ALAirport* airport = [[ALAirport alloc] initWithID:airportIdentifier
                                                          attributes:[NSDictionary dictionaryWithDictionary:attributes]];
                  [self.airportData addObject:airport];
               }
            }
         }
         
         index += 1;
         
         *stop = ((index + 1) > kMaxAirportsToLoad);
      }];
   }
   else
   {
      NSLog(@"Error loading CSV data: %@", [error localizedDescription]);
   }
}

- (void)indexAirportData
{
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      for (ALAirport* airport in self.airports)
      {
         // Create the attribute set
         CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString*)kUTTypeItem];
         
         attributeSet.displayName = airport.airportName;
         attributeSet.latitude = @(airport.coordinate.latitude);
         attributeSet.longitude = @(airport.coordinate.longitude);
         attributeSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"AppIcon"]);
         
         // Create the searchable item
         CSSearchableItem* item = [[CSSearchableItem alloc] initWithUniqueIdentifier:airport.airportIdentifier
                                                                    domainIdentifier:@"airports"
                                                                        attributeSet:attributeSet];
         
         [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item]
                                                        completionHandler:^(NSError * _Nullable error) {
                                                           NSLog(@"Indexed: %@", airport.airportName);
                                                        }];
      }
   });
}

- (NSString*)stripQuotes:(NSString*)quotedString
{
   NSUInteger length = [quotedString length];
   
   if (length > 2)
   {
      return [quotedString substringWithRange:NSMakeRange(1, [quotedString length] - 2)];
   }
   else
   {
      return quotedString;
   }
}

- (AirportType)airportTypeValue:(NSString*)value
{
   NSDictionary* airportTypes = @{@"heliport" : @(kAirportTypeHeliport),
                                  @"small_airport" : @(kAirportTypeSmallAirport),
                                  @"closed" : @(kAirportTypeClosed),
                                  @"seaplane_base" : @(kAirportTypeSeaplaneBase),
                                  @"balloonport" : @(kAirportTypeBalloonPort),
                                  @"medium_airport" : @(kAirportTypeMediumAirport),
                                  @"large_airport" : @(kAirportTypeLargeAirport)};
   
   
   return (AirportType)[airportTypes[value] integerValue];
};

@end
