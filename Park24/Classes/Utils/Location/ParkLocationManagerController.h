//
//  WMLocationManagerController.h
//  WinMinute
//
//  Created by Zo Rajaonarivony on 07/06/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ParkLocationManagerController : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *currentLocation;

+ (instancetype)sharedLocationManager;

- (void)start;
- (void)stop;

@end
