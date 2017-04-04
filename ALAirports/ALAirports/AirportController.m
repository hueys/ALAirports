//
//  AirportController.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import "AirportController.h"

@import CoreData;
@import CoreSpotlight;
@import MobileCoreServices;
@import UIKit;

#import "ALAirports-Swift.h"

#import "Airport.h"
#import "AppDelegate.h"

#define kMaxAirportsToLoad 200

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
@property (nonatomic) AirportFetcher* fetcher;

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
   return [NSArray arrayWithArray:self.airportData];
}
   
#pragma mark - Notifications
- (void)didFetchAllAirports:(NSNotification*)note
{
   dispatch_async(dispatch_get_main_queue(), ^{
      NSArray* airports = [note object];
      
      NSMutableArray* allAirports = [NSMutableArray arrayWithCapacity:[airports count]];
      
      for (NSDictionary* dict in airports)
      {
         ALAirport* airport = [[ALAirport alloc] init];
         
         [airport setValue:@([dict[@"airportId"] integerValue])
                    forKey:kAirportAttributeAirportId];
         [airport setValue:dict[@"identifer"]
                    forKey:kAirportAttributeIdentifier];
         [airport setValue:@([self airportTypeValue:dict[@"airport_type"]])
                    forKey:kAirportAttributeAirportType];
         [airport setValue:dict[@"name"]
                    forKey:kAirportAttributeName];
         [airport setValue:@"FIXME"
                    forKey:kAirportAttributeLocation];
         [airport setValue:@([dict[@"elevation"] integerValue])
                    forKey:kAirportAttributeElevation];
         [airport setValue:dict[@"isoCountry"]
                    forKey:kAirportAttributeISOCountry];
         [airport setValue:dict[@"isoRegion"]
                    forKey:kAirportAttributeISORegion];
         [airport setValue:dict[@"municipality"]
                    forKey:kAirportAttributeMunicipality];
         [airport setValue:@([dict[@"scheduledService"] isEqualToString:@"true"])
                    forKey:kAirportAttributeScheduledService];
         [airport setValue:dict[@"gpsCode"]
                    forKey:kAirportAttributeGPSCode];
         [airport setValue:dict[@"iataCode"]
                    forKey:kAirportAttributeIATACode];
         [airport setValue:dict[@"localCode"]
                    forKey:kAirportAttributeLocalCode];
         [airport setValue:dict[@"homepageUrl"]
                    forKey:kAirportAttributeHomepageURL];
         [airport setValue:dict[@"wikipediaUrl"]
                    forKey:kAirportAttributeWikipediaURL];
         
         CLLocation* location = [[CLLocation alloc] initWithLatitude:[dict[@"latitude"] doubleValue]
                                                           longitude:[dict[@"longitude"] doubleValue]];
         
         if (location)
         {
            airport.location = location;
         }
         
         [allAirports addObject:airport];
      }
      
      [self.airportData addObjectsFromArray:allAirports];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldReloadAirports"
                                                          object:nil];
   });
}

#pragma mark - ALAirportController
- (ALAirport*)airportWithIdentifier:(NSString*)identifier
{
   NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"airportIdentifier", identifier];
   
   return [self.airports filteredArrayUsingPredicate:predicate].firstObject;
}

- (void)loadAirportData
{
   if (!self.fetcher)
   {
      self.fetcher = [[AirportFetcher alloc] init];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(didFetchAllAirports:)
                                                   name:@"DidFetchAllAirports"
                                                 object:nil];
   }
   
   [self.fetcher allAirports];
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
   
- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Internal
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
