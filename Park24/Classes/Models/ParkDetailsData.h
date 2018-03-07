//
//  WMCampaignData.h
//  WinMinute
//
//  Created by Zo Andrianina on 19/07/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkDetailsData : NSObject

@property (nonatomic,strong) NSString *parkID;
@property (nonatomic,strong) NSString *parkName;
@property (nonatomic,strong) NSString *parkAddress;
@property (nonatomic,assign) NSInteger parkFreePlaceCount;
@property (nonatomic,assign) NSInteger parkType;
@property (nonatomic,assign) float latitude;
@property (nonatomic,assign) float longitude;

+ (ParkDetailsData *)parkFromDictionary:(NSDictionary *)json;

@end
