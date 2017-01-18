//
//  AirportDetailViewController.h
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import <UIKit/UIKit.h>

extern NSString* const kSegueAirportDetail;

@class ALAirport;
@interface ALAirportDetailViewController : UIViewController
@property (nonatomic, strong) ALAirport* airport;
@end
