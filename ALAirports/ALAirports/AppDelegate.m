//
//  AppDelegate.m
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

@import CoreSpotlight;

#import "AppDelegate.h"

#import "AirportsViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
   __block BOOL handledActivity = NO;
   
   UINavigationController* navigationController = (UINavigationController*)self.window.rootViewController;
   
   if (navigationController)
   {
      NSString* airportIdentifier = [userActivity userInfo][CSSearchableItemActivityIdentifier];
      
      [navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController* obj, NSUInteger idx, BOOL* stop) {
         if ([obj isKindOfClass:[ALAirportsViewController class]])
         {
            ALAirportsViewController* airportsViewController = (ALAirportsViewController*)obj;
            [airportsViewController selectAirportWithIdentifier:airportIdentifier];
            
            handledActivity = YES;
            *stop = YES;
         }
      }];
   }
   
   return handledActivity;
}
@end
