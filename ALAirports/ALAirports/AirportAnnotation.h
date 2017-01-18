//
//  AirportAnnotation.h
//  ALAirports
//
//  Created by Steve Huey on 1/18/17.
//

#import <Foundation/Foundation.h>

@import MapKit;

@class ALAirport;
@interface ALAirportAnnotation : NSObject <MKAnnotation>
- (instancetype)initWithAirport:(ALAirport*)airport;
@end
