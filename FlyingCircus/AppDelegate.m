//
//  AppDelegate.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "Imports.h"
#import "Seeder.h"

@interface AppDelegate(Private)

- (void)showSplash;
- (void)preloadYoutubePlugin;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    masterViewController.managedObjectContext = self.managedObjectContext;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // This will prevent the application from getting stcuk some seconds
    // when entering the EpisodeViewController the first time
    [self preloadYoutubePlugin];
    
    [self showSplash];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            [[[UIAlertView alloc] initWithTitle:kAlertDbErrorTitle message:kAlertDbErrorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FlyingCircus" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FlyingCircus.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [[[UIAlertView alloc] initWithTitle:kAlertDbErrorTitle message:kAlertDbErrorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
    }    
    
    // Populate DB in case it's not seeded
    if(![Seeder isPopulated:self.managedObjectContext]) {
        [Seeder populateWithContext:self.managedObjectContext];
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark
#pragma mark - Private

- (void) showSplash
{
    
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:kImageSplash];
    [self.window addSubview:splashView];
	[self.window bringSubviewToFront:splashView];
	
    // TODO: add support to animation for iOS 4?
    [UIView animateWithDuration:0.7 
                          delay:1.0 
                        options:UIViewAnimationOptionTransitionNone 
                     animations:^{
                         // Fade out
                         splashView.alpha = 0.0;
                         // Zoom in
                         splashView.frame = CGRectMake(-60, -60, 440, 600);
                         
                         // Re-show status bar
                         [[UIApplication sharedApplication] setStatusBarHidden:NO];
                         [UIApplication sharedApplication].keyWindow.frame=CGRectMake(0, 20, 320, 460);
                    }
                     completion:^(BOOL finished){
                         [splashView removeFromSuperview];
                     }];
}

- (void) preloadYoutubePlugin
{
    // Dummy UIWebView to preload Youtube plugin
    UIWebView *dummyWebView = [[UIWebView alloc] initWithFrame:self.window.rootViewController.view.frame];
    NSString *dummyHTML = kHTMLYouTubeEmbedding(@"http://www.youtube.com/watch?v=G0VkqDGZsz4",0,0);
    [dummyWebView loadHTMLString:dummyHTML baseURL:nil];
    [dummyWebView setHidden:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.window addSubview:dummyWebView];
    });
}


@end
