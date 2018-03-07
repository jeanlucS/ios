//
//  ParkUtils.m
//  Park24
//
//  Created by Zo Rajaonarivony on 10/03/14.
//  Copyright (c) 2014 Park24. All rights reserved.
//

#import "ParkUtils.h"
#import "ParkConstant.h"
#import "ParkConfig.h"

@implementation ParkUtils


/**
 Method : Show up an alert on top of screen
 */
+(void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    if ([message length]!=0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

+ (NSString *)fullMethodUrl:(NSString *)method
{
    if (method) {
        NSString *string = [NSString stringWithFormat:@"%@%@%@",PARK_SERVER_ROOT_URL, PARK_WS_URL, method];
        IGYLog(@"WS Url:%@",string)
        return string;
        
    }
    return nil;
}



@end
