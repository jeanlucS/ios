//
//  ParkViewController.h
//  Park24
//
//  Created by Zo Rajaonarivony on 10/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ParkAppDelegate.h"
#import "ParkParentViewController.h"

@interface ParkViewController : ParkParentViewController

@property(nonatomic,strong) IBOutlet GMSMapView *mapView;

@end
