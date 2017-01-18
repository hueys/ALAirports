//
//  Airport.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import "Airport.h"

NSString* const kAirportAttributeIdentifier = @"identifier";
NSString* const kAirportAttributeAirportType = @"airportType";
NSString* const kAirportAttributeName = @"name";
NSString* const kAirportAttributeLocation = @"location";
NSString* const kAirportAttributeElevation = @"elevation";
NSString* const kAirportAttributeISOCountry = @"isoCountry";
NSString* const kAirportAttributeISORegion = @"isoRegion";
NSString* const kAirportAttributeMunicipality = @"municipality";
NSString* const kAirportAttributeScheduledService = @"scheduledService";
NSString* const kAirportAttributeGPSCode = @"gpsCode";
NSString* const kAirportAttributeIATACode = @"iataCode";
NSString* const kAirportAttributeLocalCode = @"localCode";
NSString* const kAirportAttributeHomepageURL = @"homepageURL";
NSString* const kAirportAttributeWikipediaURL = @"wikipediaURL";

@import CoreLocation;

@interface ALAirport ()
@property (nonatomic, assign) NSUInteger airportId;
@property (nonatomic, copy) NSString* identifier;
@property (nonatomic, assign) AirportType airportType;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) CLLocation* location;
@property (nonatomic, assign) NSUInteger elevation;
@property (nonatomic, copy) NSString* isoCountry;
@property (nonatomic, copy) NSString* isoRegion;
@property (nonatomic, copy) NSString* municipality;
@property (nonatomic, assign) BOOL scheduledService;
@property (nonatomic, copy) NSString* gpsCode;
@property (nonatomic, copy) NSString* iataCode;
@property (nonatomic, copy) NSString* localCode;
@property (nonatomic, copy) NSURL* homepageURL;
@property (nonatomic, copy) NSURL* wikipediaURL;

- (void)setAttributes:(NSDictionary*)attributes;
- (NSString*)descriptionOfAirportType;
- (NSString*)descriptionOfISORegion;
@end

@implementation ALAirport
- (instancetype)initWithID:(NSUInteger)airportIdentifier
                attributes:(NSDictionary*)attributes
{
   self = [super init];
   
   if (self)
   {
      _airportId = airportIdentifier;
      [self setAttributes:attributes];
   }
   
   return self;
}

#pragma mark - Properties
- (NSString *)detailedDescription
{
   return [NSString stringWithFormat:@"%@ in %@, %@", [self descriptionOfAirportType],
           self.municipality, [self descriptionOfISORegion]];
}

- (NSString *)airportName
{
   return self.name;
}

- (NSString *)airportIdentifier
{
   return self.identifier;
}

- (NSString *)type
{
   return [self descriptionOfAirportType];
}

- (CLLocationCoordinate2D)coordinate
{
   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
   
   if (self.location)
   {
      coordinate = self.location.coordinate;
   }
   
   return coordinate;
}

#pragma mark - Internal
- (void)setAttributes:(NSDictionary*)attributes
{
   [self setValuesForKeysWithDictionary:attributes];
}

- (NSString*)descriptionOfAirportType
{
   NSDictionary* descriptions = @{@(kAirportTypeHeliport): @"Heliport",
                                  @(kAirportTypeSmallAirport): @"Small Airport",
                                  @(kAirportTypeMediumAirport): @"Medium Airport",
                                  @(kAirportTypeLargeAirport): @"Large Airport",
                                  @(kAirportTypeSeaplaneBase): @"Seaplane Base",
                                  @(kAirportTypeBalloonPort): @"Balloon Port",
                                  @(kAirportTypeClosed): @"Closed Facility"};
   
   return descriptions[@(self.airportType)];
}

- (NSString*)descriptionOfISORegion
{
   return [self.isoRegion substringFromIndex:3];
}

#pragma mark - NSObject
- (NSUInteger)hash
{
   return self.airportId;
}

- (BOOL)isEqual:(id)object
{
   BOOL result = NO;
   
   if ([object isKindOfClass:[self class]])
   {
      ALAirport* otherAirport = (ALAirport*)object;
      result = (self.airportId == otherAirport.airportId);
   }
   
   return result;
}
@end
