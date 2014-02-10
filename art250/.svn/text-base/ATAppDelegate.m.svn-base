//
//  ATAppDelegate.m
//  art250
//
//  Created by Winfred Raguini on 8/9/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import "ATAppDelegate.h"
#import "ATArtContainerViewController.h"
#import "ATGlobalConstants.h"
#import "ATSplashViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ATFacebookManager.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "ATAPIClient.h"
#import "ATArtManager.h"
#include <stdlib.h>
#import "BPCustomer.h"
//#import <HockeySDK/HockeySDK.h>
#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>
#import "ATUserManager.h"
//#import <Vessel/Vessel.h>
#import "ATSettingsNavigationController.h"
#import "UIImageView+AFNetworking.h"
#import "Mixpanel.h"
#import "ATDatabaseManager.h"

#define NUM_SPLASH_ARTWORK 3

@interface ATAppDelegate ()
@property (nonatomic, strong) UIImageView *splashImageView;
- (void)noInternetConnectionAlert;
@end


@implementation ATAppDelegate
@synthesize navigationController = navigationController_;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Restkit Logging
    RKLogConfigureByName("RestKit", RKLogLevelWarning);
    
    RKLogConfigureByName("*", RKLogLevelOff);
    
    
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024
                                                      diskCapacity:32*1024*1024
                                                          diskPath:@"app_cache"];
    
    // Set the shared cache to our new instance
    [NSURLCache setSharedURLCache:cache];
    
    
    
    [Vessel initializeWithAppSecret:VESSEL_API_KEY];

    
//    [TestFlight takeOff:@"21fa5a0e-4e5d-46e1-8d16-312a2fe785aa"];
#ifdef DEBUG
    [Parse setApplicationId:@"FbbBaVueYPBETuUVzbeCfo68ZqGOUPH1U7kBhtGo" clientKey:@"TOY67vlSSAhXv63u1Qj86IrNr7bImPJDOk6x4AfY"];
#else
    [Parse setApplicationId:@"au66REDJoRcpB7gKNIbAQB6vPqY3VzB4aUd3z3G9" clientKey:@"s7RZOIdyf12LNv9J44xmFHJHLIQL5tmkq19cGbNr"];
#endif
    
    
//    [Vessel initializeWithAppSecret:@"WVU2UmhiUzBkTW5zcTdLRGpHRUk5Mm1s"];
//    [VesselCrashReporter enableCrashReporting];

    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
//    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"d9509ac2b195967b3aaa3c4db94ea9f5"
//                                                           delegate:self];
//    [[BITHockeyManager sharedHockeyManager] startManager];
//
    
    //DELETED NSUserDefaults
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[ATSettingsNavigationController class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];


    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], UITextAttributeTextColor,
//                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
//                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
//                                                           UITextAttributeTextShadowOffset,
//                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont, nil]];


    
    //NSLog(@"BP customer %@", [[NSUserDefaults standardUserDefaults] objectForKey:kBPCustomersKey]);
    
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kBPCustomersKey];
    
//    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    //NSLog(@"why isn't it showing anything %@", dict);
    //NSLog(@"win's info %@", [dict objectForKey:@"bc@bc.com"]);
    
    NSLog(@"before flurry");
#ifdef DEBUG
    [Flurry startSession:FLURRY_DEV_API_KEY];
#else
    [Flurry startSession:FLURRY_PROD_API_KEY];
#endif
    NSLog(@"after flurry");
    

    
#ifdef DEBUG
    [Mixpanel sharedInstanceWithToken:DEV_MIXPANEL_TOKEN];
#else
    [Mixpanel sharedInstanceWithToken:PROD_MIXPANEL_TOKEN];
#endif

    [Crashlytics startWithAPIKey:@"611a687d5eb4dfd712e721d935712922abbbac2d"];
   
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    ATPaintingResultsViewController *resultsController = [[ATPaintingResultsViewController alloc] initWithNibName:@"ATPaintingResultsViewController" bundle:nil];
    
   // ATSearchViewController *searchController = [[ATSearchViewController alloc] initWithNibName:@"ATSearchViewController" bundle:nil];
    
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar_logo.png"] forBarMetrics:UIBarMetricsDefault];
    

    [[ATAPIClient sharedClient] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        //NSLog(@"status %i", status);
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [self noInternetConnectionAlert];
                break;
                
            default:
                break;
        }
    }];
    
    //Load FB stuff
    [FBLoginView class];
    NSLog(@"fblogin class called");
    
    
    
    ATArtContainerViewController *artContainerController = [[ATArtContainerViewController alloc] initWithNibName:@"ATArtContainerViewController" bundle:nil];

    //This will add the random artwork background
    self.splashImageView = [[UIImageView alloc]initWithImage:[[ATArtManager sharedManager] artworkSplashImage]];
    //UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"launch_start_clear.png"]];
    //[self.splashImageView addSubview:logoImageView];

    
    [[artContainerController view] addSubview:self.splashImageView];
    [[artContainerController view] bringSubviewToFront:self.splashImageView];


    
    self.window.rootViewController = artContainerController;

    [self.window makeKeyAndVisible];

    
    
    [self performSelector:@selector(removeSplash) withObject:nil afterDelay:3.0];

    return YES;
}


//- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
//#ifndef CONFIGURATION_AppStore
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
//        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
//#endif
//    return nil;
//}

- (void)removeSplash
{
    //now fade out splash image
    [UIView transitionWithView:self.window duration:1.0f options:UIViewAnimationOptionTransitionNone animations:^(void){
        self.splashImageView.alpha=0.0f;
    } completion:^(BOOL finished){
        [self.splashImageView removeFromSuperview];
    }];
}

+ (BOOL)systemGreaterThanVersion:(NSString*)reqSysVer
{
    //@"7.0"
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    return ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [Flurry endTimedEvent:FL_BEGAN_ARTTWO50_SESSION withParameters:nil];
    
    [VesselAB endAllSessions];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [UIImageView clearImageCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [VesselAB startSession:VESSEL_ARTTWO50_SESSION];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    [[ATTrackingManager sharedManager] trackEvent:FL_BEGAN_ARTTWO50_SESSION timed:YES];
    
    [[ATUserManager sharedManager] resetFlurryData];
    
    [FBSession.activeSession handleDidBecomeActive];
    
    if ([[ATDatabaseManager sharedManager] didImportArtistProfiles]) {
        [[ATArtManager sharedManager] updateArtistProfiles];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Save data if appropriate
    // Facebook SDK * pro-tip *
    // if the app is going away, we close the session object; this is a good idea because
    // things may be hanging off the session, that need releasing (completion block, etc.) and
    // other components in the app may be awaiting close notification in order to do cleanup
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // add app-specific handling code here
    return wasHandled;
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance]];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  //NSLog(@"Errors: %@", [error description]);
                                  //[self.loginViewController loginView:nil handleError:error];
                              }
                          }];
}

- (void)noInternetConnectionAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connectivity" message:@"You'll need internet to see some art." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}






@end
