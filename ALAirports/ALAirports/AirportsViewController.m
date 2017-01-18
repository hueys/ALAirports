//
//  AirportsViewController.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

@import CoreSpotlight;

#import "AirportsViewController.h"

#import "Airport.h"
#import "AirportController.h"
#import "AirportDetailViewController.h"
#import "AirportTableViewCell.h"

@interface ALAirportsViewController ()
@property (nonatomic, strong) ALAirportController* airportController;

- (ALAirport*)airportAtIndexPath:(NSIndexPath*)indexPath;
@end

@implementation ALAirportsViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
   [super viewDidLoad];

   self.airportController = [ALAirportController defaultController];
}

#pragma mark - ALAirportsViewController
- (void)selectAirportWithIdentifier:(NSString*)identifier
{
   ALAirport* airport = [self.airportController airportWithIdentifier:identifier];
   
   if (airport)
   {
      [self performSegueWithIdentifier:kSegueAirportDetail
                                sender:airport];
   }
}

#pragma mark - Internal
- (ALAirport*)airportAtIndexPath:(NSIndexPath*)indexPath
{
   return self.airportController.airports[indexPath.row];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier] isEqualToString:kSegueAirportDetail])
   {
      ALAirportDetailViewController* detailViewController = (ALAirportDetailViewController*)segue.destinationViewController;
      
      if ([sender isKindOfClass:[ALAirportTableViewCell class]])
      {
         ALAirportTableViewCell* cell = (ALAirportTableViewCell*)sender;
         detailViewController.airport = cell.airport;
      }
      else if ([sender isKindOfClass:[ALAirport class]])
      {
         detailViewController.airport = sender;
      }
   }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.airportController.airports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   ALAirportTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[ALAirportTableViewCell reuseIdentifier]
                                                                  forIndexPath:indexPath];
   
   if (cell)
   {
      cell.airport = [self airportAtIndexPath:indexPath];
   }
   
   return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ALAirportTableViewCell* cell = (ALAirportTableViewCell*)[self tableView:tableView
                                                     cellForRowAtIndexPath:indexPath];
   
   [self performSegueWithIdentifier:kSegueAirportDetail
                             sender:cell];
}
@end
