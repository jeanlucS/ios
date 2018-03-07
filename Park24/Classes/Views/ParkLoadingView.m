//
//  WMLoadingView.m
//  WinMinute
//
//  Created by Zo Rajaonarivony on 03/09/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import "ParkLoadingView.h"

@implementation ParkLoadingView

+ (id)loadFromNIB
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ParkLoadingView"
                                                   owner:nil
                                                 options:nil];
    if (array.count > 0) {
        UIView *v = [array objectAtIndex:0];
        v.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
        return v;
    }
    
    return nil;
}


@end
