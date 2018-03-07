//
//  ParkParentViewController.h
//  Park24
//
//  Created by Zo Rajaonarivony on 12/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkAppDelegate.h"
#import "ParkLoadingView.h"

@interface ParkParentViewController : UIViewController
{
    ParkAppDelegate *_appDelegate;
    ParkLoadingView *_loadingView;
}

- (void)startLoadingView;
- (void)stopLoadingView;

@end
