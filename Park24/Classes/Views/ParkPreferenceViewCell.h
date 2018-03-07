//
//  ParkPreferenceViewCell.h
//  Park24
//
//  Created by Zo Rajaonarivony on 11/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ParkPreferenceViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *prefItemTitle;
@property (strong, nonatomic) IBOutlet UISwitch *switchItem;
@property (strong, nonatomic) IBOutlet UIButton *optionButtonItem;


@end