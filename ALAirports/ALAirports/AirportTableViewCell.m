//
//  AirportTableViewCell.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import "AirportTableViewCell.h"

#import "Airport.h"

@interface ALAirportTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* detailLabel;

- (void)setName:(NSString*)name;
- (void)setDetail:(NSString*)detail;
@end

@implementation ALAirportTableViewCell
#pragma mark - Class Methods
+ (NSString*) reuseIdentifier
{
   return @"AirportTableViewCell";
}

#pragma mark - Properties
- (void)setAirport:(ALAirport *)airport
{
   _airport = airport;
   
   [self setName:[airport valueForKey:kAirportAttributeName]];
   [self setDetail:airport.detailedDescription];
}

#pragma mark - Internal
- (void)setName:(NSString*)name
{
   self.nameLabel.text = name;
}

- (void)setDetail:(NSString*)detail
{
   self.detailLabel.text = detail;
}
@end
