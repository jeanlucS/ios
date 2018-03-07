//
//  ParkConstant.h
//  Park24
//
//  Created by Zo Rajaonarivony on 10/03/14.
//  Copyright (c) 2014 Park24. All rights reserved.
//

#define PARK_DEBUG_MODE 1

#if PARK_DEBUG_MODE
#warning Warning - Application in Debug Mode, lot of Log appearing
#endif


#define LocalizedString(_pointer) NSLocalizedString(_pointer, @"")

#if PARK_DEBUG_MODE
#define IGYLog(_pointer, ...) NSLog((@"%s [Line %d] " _pointer), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define IGYLog(_pointer, ...) ((void)0);
#endif

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IOS_PRIOR_7 [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_WS_RETURNED_OK(wsDictionary) [[[wsDictionary objectForKey:@"status"] objectForKey:@"code"] isEqualToString:@"OK"]

#define PARK_WS_DATA_ENCODING NSUTF8StringEncoding


#define LocalizedString(_pointer) NSLocalizedString(_pointer, @"")


typedef void (^completionBlock)(id, NSError *);

// Google maps
//#define PARK_GOOGLE_MAPS_API_KEY @"AIzaSyDoJ-vYYhkQWYClc3-Fb0OJwAV_QyevrJo"
#define PARK_GOOGLE_MAPS_API_KEY @"AIzaSyDo7H_6m2oUV0HDvmZZMSOwhLoUfO-bxew"

// Notification Identifier
#define PARK_NOTIFICATION_KEY_LOCATION_UPDATED_NOTIFICATION @"PARK_NOTIFICATION_KEY_LOCATION_UPDATED_NOTIFICATION"
#define PARK_NOTIFICATION_KEY_LOCATION_ERROR_NOTIFICATION @"PARK_NOTIFICATION_KEY_LOCATION_ERROR_NOTIFICATION"
#define PARK_NOTIFICATION_KEY_DEVICE_TOKEN_NOTIFICATION @"PARK_NOTIFICATION_KEY_DEVICE_TOKEN_NOTIFICATION"
#define PARK_NOTIFICATION_KEY_NEW_MISSION_NOTIFICATION_FROM_PUSH @"PARK_NOTIFICATION_KEY_NEW_MISSION_NOTIFICATION_FROM_PUSH"



