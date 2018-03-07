//
//  ParkPreferenceData.m
//  Park24
//
//  Created by Zo Rajaonarivony on 12/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import "ParkPreferenceData.h"

@implementation ParkPreferenceData

-(void)initPreference
{
    self.selectedTypologieForFiltre = @"";
    self.selectedTarificationForFiltre = @"";
    self.morethanfour = NO;
    self.morethantwo = NO;
    self.lessthantwo = NO;
    self.all = YES;
    self.userCurrentLongitude = 0.0;
    self.userCurrentLatitude = 0.0;
}


@end
