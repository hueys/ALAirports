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
#import "SearchResultsViewController.h"

@interface ALAirportsViewController () <UISearchResultsUpdating>
@property (nonatomic, strong) ALAirportController* airportController;

@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) CSSearchQuery* searchQuery;
@property (nonatomic, strong) NSMutableArray* searchResults;

- (ALAirport*)airportAtIndexPath:(NSIndexPath*)indexPath;
- (void)setupSearchController;
- (void)searchFor:(NSString*)query;
- (void)updateSearchResults;
@end

@implementation ALAirportsViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
   [super viewDidLoad];

   [self setupSearchController];
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

- (void)setupSearchController
{
   self.definesPresentationContext = YES;
   
   UIViewController* searchResultsController = [[self storyboard]
                                                instantiateViewControllerWithIdentifier:@"SearchResultsController"];
   self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
   
   self.searchController.searchResultsUpdater = self;
   self.searchController.hidesNavigationBarDuringPresentation = NO;
   self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
   self.searchController.searchBar.tintColor = [UIColor whiteColor];
   
   [self.searchController.searchBar sizeToFit];
   self.tableView.tableHeaderView = self.searchController.searchBar;
   
   self.searchResults = [NSMutableArray arrayWithCapacity:0];
}

- (void)searchFor:(NSString*)query
{
   if (self.searchQuery)
   {
      [self.searchQuery cancel];
      self.searchQuery = nil;
      [self.searchResults removeAllObjects];
      [self updateSearchResults];
   }
   
   NSString* queryString = [NSString stringWithFormat:@"displayName == '*%@*'c", query];
   self.searchQuery = [[CSSearchQuery alloc] initWithQueryString:queryString
                                                      attributes:@[@"displayName"]];
   
   __weak typeof(self) weakSelf = self;
   self.searchQuery.foundItemsHandler = ^(NSArray<CSSearchableItem *> *items) {
      for (CSSearchableItem* item in items)
      {
         ALAirport* airport = [weakSelf.airportController
                               airportWithIdentifier:[item uniqueIdentifier]];
         
         [weakSelf.searchResults addObject:airport];
         [weakSelf updateSearchResults];
      }
   };
   
   self.searchQuery.completionHandler = ^(NSError* error) {
      if (error)
      {
         NSLog(@"%@", error);
      }
      else
      {
         [weakSelf updateSearchResults];
      }
   };
   
   [self.searchQuery start];
}

- (void)updateSearchResults
{
   dispatch_async(dispatch_get_main_queue(), ^{
      // Update the search results view controller
      UINavigationController* searchResultsNavController = (UINavigationController*)self.searchController.searchResultsController;
      ALSearchResultsViewController* viewController = (ALSearchResultsViewController*)searchResultsNavController.topViewController;
      
      viewController.searchResults = [NSArray arrayWithArray:self.searchResults];
      [viewController.tableView reloadData];
   });
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

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
   NSString* query = searchController.searchBar.text;
   
   // Update searchResults
   if (!query || (0 == [query length]))
   {
      [self.searchResults setArray:@[]];
      [self updateSearchResults];
   }
   else
   {
      [self searchFor:query];
   }
}
@end
