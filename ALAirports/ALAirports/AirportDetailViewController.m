//
//  AirportDetailViewController.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

#import "AirportDetailViewController.h"

@import MapKit;

#import "Airport.h"
#import "AirportAnnotation.h"

NSString* const kSegueAirportDetail = @"AirportDetail";

#define kDefaultRegionDistanceInMeters 1600

@interface ALAirportDetailViewController ()
@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* typeLabel;
@property (weak, nonatomic) IBOutlet UILabel* identifierLabel;

@property (nonatomic, strong) ALAirportAnnotation* airportAnnotation;
@end

@implementation ALAirportDetailViewController

#pragma mark - UIViewController
- (void)viewWillAppear:(BOOL)animated
{
   if (self.airport)
   {
      self.nameLabel.text = self.airport.airportName;
      self.typeLabel.text = self.airport.type;
      self.identifierLabel.text = self.airport.airportIdentifier;
      
      [self.mapView addAnnotation:self.airportAnnotation];
      
      MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(self.airportAnnotation.coordinate,
                                                                        kDefaultRegionDistanceInMeters,
                                                                        kDefaultRegionDistanceInMeters);
      [self.mapView setRegion:mapRegion];
   }
}

#pragma mark - Properties
- (ALAirportAnnotation *)airportAnnotation
{
   if (!_airportAnnotation)
   {
      _airportAnnotation = [[ALAirportAnnotation alloc] initWithAirport:self.airport];
   }
   
   return _airportAnnotation;
}
@end
