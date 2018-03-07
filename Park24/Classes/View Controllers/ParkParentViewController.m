//
//  ParkParentViewController.m
//  Park24
//
//  Created by Zo Rajaonarivony on 12/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import "ParkParentViewController.h"

@interface ParkParentViewController ()

@end

@implementation ParkParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_appDelegate) {
        _appDelegate = (ParkAppDelegate *) [UIApplication sharedApplication].delegate;
    }
    // Load LoadingView In Memory
    if (!_loadingView) {
        _loadingView = [ParkLoadingView loadFromNIB];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods
- (void)startLoadingView
{
    [self.view addSubview:_loadingView];
}

- (void)stopLoadingView
{
    [_loadingView removeFromSuperview];
}

@end
