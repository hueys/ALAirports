//
//  SearchResultsViewController.h
//  ALAirports
//
//  Created by Steve Huey on 1/26/17.
//

#import <UIKit/UIKit.h>

@class ALAirport;
@interface ALSearchResultsViewController : UITableViewController
@property (nonatomic, strong) NSArray<ALAirport*>* searchResults;
@end
