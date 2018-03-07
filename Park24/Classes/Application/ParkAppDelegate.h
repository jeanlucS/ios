//
//  WMAppDelegate.h
//  WinMinute
//
//  Created by Ingenosya on 23/05/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "ParkUtils.h"
#import "ParkPreferenceData.h"


@interface ParkAppDelegate : UIResponder <UIApplicationDelegate> {
    Reachability *_hostReach;
    Reachability *_internetReach;
    Reachability *_wifiReach;
    NSMutableArray *typologie;
    NSMutableArray *tarification;
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ParkUtils *utils;
@property (strong, nonatomic) ParkPreferenceData *preferenceData;
@property (nonatomic, assign) BOOL mapViewWithOptions;

@end
