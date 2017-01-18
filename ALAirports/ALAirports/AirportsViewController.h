//
//  AirportsViewController.h
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import <UIKit/UIKit.h>

@class ALAirport;
@interface ALAirportsViewController : UITableViewController

- (void)selectAirportWithIdentifier:(NSString*)identifier;
@end
