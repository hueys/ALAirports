//
//  AirportController.h
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import <Foundation/Foundation.h>

typedef void(^AirportControllerImportCompletionHandler)();

@class ALAirport;
@interface ALAirportController : NSObject
@property (nonatomic, readonly) NSArray* airports;

+ (instancetype)defaultController;

- (ALAirport*)airportWithIdentifier:(NSString*)identifier;
@end
