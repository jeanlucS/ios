//
//  PreferenceViewController.h
//  Park24
//
//  Created by Zo Rajaonarivony on 11/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkPreferenceData.h"
#import "ParkParentViewController.h"

@interface ParkPreferenceViewController : ParkParentViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *typoParcArray;
    NSMutableArray *typeTarifArray;
    NSArray *disponibilityPlaceArray;
}
@property(nonatomic,strong) IBOutlet UIButton *savePref;
@property(nonatomic,strong) IBOutlet UITableView *tablePref;

@end
