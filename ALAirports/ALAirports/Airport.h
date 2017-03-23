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

@interface ALAirport : NSObject
@property (nonatomic, readonly) NSString* detailedDescription;
@property (nonatomic, readonly) NSString* airportName;
@property (nonatomic, readonly) NSString* airportIdentifier;
@property (nonatomic, readonly) NSString* type;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
   
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


- (void)setAttributes:(NSDictionary*)attributes;
@end
