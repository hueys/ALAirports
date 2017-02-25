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
@property (strong, nonatomic, readwrite) NSPersistentContainer* persistentContainer;
@property (strong, nonatomic, readwrite) NSManagedObjectContext* backgroundContext;

- (void)setupCoreDataStack;
@end

@implementation AppDelegate
#pragma mark - Properties
- (NSManagedObjectContext*)backgroundContext
{
   if (!_backgroundContext)
   {
      _backgroundContext = [self.persistentContainer newBackgroundContext];
   }
   
   return _backgroundContext;
}

- (BOOL)hasAirportData
{
   NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Airport"];
   
   NSUInteger count = [self.persistentContainer.viewContext countForFetchRequest:fetchRequest
                                                                           error:nil];
   
   return (count > 0);
}

#pragma mark - Internal
- (void)setupCoreDataStack
{
   static dispatch_once_t onceToken;
   
   dispatch_once(&onceToken, ^{
      self.persistentContainer = [NSPersistentContainer persistentContainerWithName:@"AirportsModel"];
   });
}

#pragma mark - UIApplicationDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
   [self setupCoreDataStack];
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
