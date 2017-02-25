//
//  Airport.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import "Airport.h"

NSString* const kAirportAttributeAirportId = @"airportId";
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
@property (nonatomic, copy) NSString* homepageURL;
@property (nonatomic, copy) NSString* wikipediaURL;

- (NSString*)descriptionOfAirportType;
- (NSString*)descriptionOfISORegion;
@end

@implementation ALAirport
@dynamic airportId;
@dynamic identifier;
@dynamic airportType;
@dynamic name;
@dynamic location;
@dynamic elevation;
@dynamic isoCountry;
@dynamic isoRegion;
@dynamic municipality;
@dynamic scheduledService;
@dynamic gpsCode;
@dynamic iataCode;
@dynamic localCode;
@dynamic homepageURL;
@dynamic wikipediaURL;

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

#pragma mark - ALAirport
- (void)setAttributes:(NSDictionary*)attributes
{
   [self setValuesForKeysWithDictionary:attributes];
}

#pragma mark - Internal
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
@end
