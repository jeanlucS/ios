//
//  WMWebServiceClient.h
//  WinMinute
//
//  Created by Zo Rajaonarivony on 29/05/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkDetailsData.h"
#import "ParkUtils.h"
#import "ParkConstant.h"

@protocol ParkWebServiceClientDelegate;

@interface ParkWebServiceClient : NSObject {
    NSURLConnection *_urlConnection;
    NSMutableData *_jsonData;
}

// Singleton
+ (instancetype)sharedInstance;

@property (nonatomic, copy) completionBlock completionResult;

// Public Methods
- (void)startFetchingParkList:(NSDictionary*) parameters completionBlock:(completionBlock)completionResult;
- (void)startFetchingParkListWithFiltre:(NSDictionary*) parameters completionBlock:(completionBlock) completionResult;
- (void)startFetchingSelectedParkInfos:(NSDictionary*) parameters completionBlock:(completionBlock) completionResult;
- (void)startPostingTokenWS:(NSString *)token completionBlock:(completionBlock )completionResult;

- (void)startFetchingTypoListWithCompletionBlock:(completionBlock )completionResult;
- (void)startFetchingTarifListWithCompletionBlock:(completionBlock )completionResult;

@end
