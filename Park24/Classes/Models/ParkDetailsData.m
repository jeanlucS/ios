//
//  WMCampaignListeData.m
//  Park24
//
//  Created by Zo Andrianina on 19/07/13.
//  Copyright (c) 2013 Park24. All rights reserved.
//

#import "ParkDetailsData.h"

@implementation ParkDetailsData

@synthesize parkID;
@synthesize parkName;
@synthesize parkAddress;
@synthesize parkFreePlaceCount;
@synthesize parkType;
@synthesize latitude;
@synthesize longitude;


+ (ParkDetailsData *)parkFromDictionary:(NSDictionary *)json
{
    ParkDetailsData *park = [[ParkDetailsData alloc] init];
    
    park.parkID = [json objectForKey:@"parc_id"];
    park.parkName = [json objectForKey:@"nom"];
    park.parkAddress = [json objectForKey:@"adresse"];
    //park.parkType = [[json objectForKey:@"typologie_id"] intValue];
    park.parkFreePlaceCount = [[json objectForKey:@"free_place_count"] intValue];
    if (![[json objectForKey:@"longitude"] isEqual:[NSNull null]] &&
        ![[json objectForKey:@"latitude"] isEqual:[NSNull null]]) {
        park.longitude = [[json objectForKey:@"longitude"]floatValue];
        park.latitude =[[json objectForKey:@"latitude"]floatValue];
    }else{
        park.longitude = 0;
        park.latitude =0;
    }
    // It's important a park has a valid location
    /*if ([[[json objectForKey:@"location"] objectForKey:@"longitude"] isEqualToString:@""] || [[[json objectForKey:@"location"] objectForKey:@"latitude"] isEqualToString:@""]) {
        return nil;
    }*/
    
    return park;
}

@end
