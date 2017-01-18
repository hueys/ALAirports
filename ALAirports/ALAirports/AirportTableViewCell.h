//
//  AirportTableViewCell.h
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import <UIKit/UIKit.h>

@class ALAirport;
@interface ALAirportTableViewCell : UITableViewCell
@property (nonatomic, strong) ALAirport* airport;

+ (NSString*) reuseIdentifier;
@end
