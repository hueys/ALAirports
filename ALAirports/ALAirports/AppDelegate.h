//
//  AppDelegate.h
//  ALAirports
//
//  Created by Steven Huey on 1/18/17.
//

@import CoreData;
@import UIKit;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) NSPersistentContainer* persistentContainer;
@property (nonatomic, readonly) NSManagedObjectContext* backgroundContext;
@end

