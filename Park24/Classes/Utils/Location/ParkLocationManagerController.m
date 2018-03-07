//
//  WMLocationManagerController.m
//  WinMinute
//
//  Created by Zo Rajaonarivony on 07/06/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import "ParkLocationManagerController.h"
#import "ParkConstant.h"

@implementation ParkLocationManagerController


#pragma mark - Class Methods
+ (instancetype)sharedLocationManager
{
    static dispatch_once_t pred;
    static ParkLocationManagerController *sharedLocationManager = nil;
    
    dispatch_once(&pred, ^{
        sharedLocationManager = [[ParkLocationManagerController alloc] init];
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = sharedLocationManager;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        sharedLocationManager.locationManager = locationManager;
    });
    
    return sharedLocationManager;
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //IGYLog(@"--locationManager::didUpdateToLocation:%f-%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    _currentLocation = newLocation;
    [[NSNotificationCenter defaultCenter] postNotificationName:PARK_NOTIFICATION_KEY_LOCATION_UPDATED_NOTIFICATION
                                                        object:_currentLocation
                                                      userInfo:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    IGYLog(@"--locationManager::didFailWithError:%@", [error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:PARK_NOTIFICATION_KEY_LOCATION_ERROR_NOTIFICATION
                                                        object:error
                                                      userInfo:nil];
}

#pragma mark - Public Methods

- (void)start
{
    [self stop];
    [_locationManager startUpdatingLocation];
}

- (void)stop
{
    [_locationManager stopUpdatingLocation];
}

@end
