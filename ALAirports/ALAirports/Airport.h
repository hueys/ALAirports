//
//  Airport.h
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import <Foundation/Foundation.h>

@import CoreData;
@import CoreLocation;

typedef NS_ENUM(NSUInteger, AirportType) {
   kAirportTypeHeliport,
   kAirportTypeSmallAirport,
   kAirportTypeMediumAirport,
   kAirportTypeLargeAirport,
   kAirportTypeSeaplaneBase,
   kAirportTypeBalloonPort,
   kAirportTypeClosed
};

extern NSString* const kAirportAttributeAirportId;
extern NSString* const kAirportAttributeIdentifier;
extern NSString* const kAirportAttributeAirportType;
extern NSString* const kAirportAttributeName;
extern NSString* const kAirportAttributeLocation;
extern NSString* const kAirportAttributeElevation;
extern NSString* const kAirportAttributeISOCountry;
extern NSString* const kAirportAttributeISORegion;
extern NSString* const kAirportAttributeMunicipality;
extern NSString* const kAirportAttributeScheduledService;
extern NSString* const kAirportAttributeGPSCode;
extern NSString* const kAirportAttributeIATACode;
extern NSString* const kAirportAttributeLocalCode;
extern NSString* const kAirportAttributeHomepageURL;
extern NSString* const kAirportAttributeWikipediaURL;

@interface ALAirport : NSManagedObject
@property (nonatomic, readonly) NSString* detailedDescription;
@property (nonatomic, readonly) NSString* airportName;
@property (nonatomic, readonly) NSString* airportIdentifier;
@property (nonatomic, readonly) NSString* type;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (void)setAttributes:(NSDictionary*)attributes;
@end
