//
//  AirportAnnotation.m
//  ALAirports
//
//  Created by Steve Huey on 1/18/17.
//

#import "AirportAnnotation.h"

#import "Airport.h"

@interface ALAirportAnnotation ()
@property (nonatomic, strong) ALAirport* airport;
@end

@implementation ALAirportAnnotation
- (instancetype)initWithAirport:(ALAirport *)airport
{
   self = [super init];
   
   if (self)
   {
      _airport = airport;
   }
   
   return self;
}

#pragma mark - MKAnnotation
- (CLLocationCoordinate2D)coordinate
{
   return self.airport.coordinate;
}

- (NSString *)title
{
   return self.airport.airportName;
}

- (NSString *)subtitle
{
   return [self.airport detailedDescription];
}
@end
