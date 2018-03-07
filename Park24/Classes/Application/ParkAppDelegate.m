//
//  WMAppDelegate.m
//  WinMinute
//
//  Created by Ingenosya on 23/05/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import "ParkAppDelegate.h"
#import "ParkConfig.h"
#import "ParkConstant.h"
#import <GoogleMaps/GoogleMaps.h>


@implementation ParkAppDelegate

#pragma mark - Application lifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    // Initialize Device Reachability Features
    [self initReachability];
    self.utils = [[ParkUtils alloc] init];
    self.preferenceData = [[ParkPreferenceData alloc] init];
    [self.preferenceData initPreference];
    self.mapViewWithOptions = NO;
    [GMSServices provideAPIKey:PARK_GOOGLE_MAPS_API_KEY];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    self.utils = nil;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Reinitialize Badge Icon Everytime User Lunches The App
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


#pragma mark - Private Methods
- (void)initReachability
{
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    // Reachability
    _hostReach = [Reachability reachabilityWithHostname:PARK_SERVER_ROOT_URL];
    [_hostReach startNotifier];
    
    _internetReach = [Reachability reachabilityForInternetConnection];
    [_internetReach startNotifier];
    
    _wifiReach = [Reachability reachabilityForLocalWiFi];
}

#pragma mark - Reachability Notification
- (void)reachabilityChanged:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
}

// Push Notification Delegate
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    /*if (self.registeredUserData) {
        self.registeredUserData.acceptNotification = YES;
    }*/
    NSLog(@"My token is: %@", deviceTokenStr);
    // TODO - Send Token To Server
    [[NSNotificationCenter defaultCenter] postNotificationName:PARK_NOTIFICATION_KEY_DEVICE_TOKEN_NOTIFICATION object:deviceTokenStr];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // The user didn't accept to receive notification
    /*if (self.registeredUserData) {
        self.registeredUserData.acceptNotification = NO;
    }*/
    
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PARK_NOTIFICATION_KEY_NEW_MISSION_NOTIFICATION_FROM_PUSH object:nil];
    }
}


@end
