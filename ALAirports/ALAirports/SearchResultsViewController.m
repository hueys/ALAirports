//
//  SearchResultsViewController.m
//  ALAirports
//
//  Created by Steve Huey on 1/26/17.
//

#import "SearchResultsViewController.h"

#import "Airport.h"
#import "AirportTableViewCell.h"

@interface ALSearchResultsViewController ()
@end

@implementation ALSearchResultsViewController

#pragma mark - UIViewController
-(void)viewDidLoad
{
   [super viewDidLoad];
   
   self.searchResults = @[];
}

- (void)viewWillAppear:(BOOL)animated
{
   CGFloat yOrigin = self.tableView.frame.origin.y;
   
   if (yOrigin != 44)
   {
      CGRect frame = self.tableView.frame;
      self.tableView.frame = CGRectMake(0, 44, frame.size.width, frame.size.height);
   }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return (self.searchResults ? [self.searchResults count] : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   ALAirportTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[ALAirportTableViewCell reuseIdentifier]
                                                                  forIndexPath:indexPath];
   
   if (cell)
   {
      cell.airport = self.searchResults[indexPath.row];
   }
   
   return cell;
}
@end
