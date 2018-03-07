//
//  ParkPreferenceData.h
//  Park24
//
//  Created by Zo Rajaonarivony on 12/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkPreferenceData : NSObject

@property (nonatomic, strong) NSString *selectedTypologieForFiltre;
@property (nonatomic, strong) NSString *selectedTarificationForFiltre;

// disponibilité de place
@property (nonatomic, assign, getter = isMorethanfour) BOOL morethanfour;
@property (nonatomic, assign, getter = isMorethantwo) BOOL morethantwo;
@property (nonatomic, assign, getter = isLessthantwo) BOOL lessthantwo;
@property (nonatomic, assign, getter = isAll) BOOL all;

@property (nonatomic, assign) double userCurrentLatitude;
@property (nonatomic, assign) double userCurrentLongitude;
@property (nonatomic, assign) BOOL geolocSmartphoneEnabled;

-(void)initPreference;


@end
