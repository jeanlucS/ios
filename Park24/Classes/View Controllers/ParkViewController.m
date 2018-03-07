//
//  ParkViewController.m
//  Park24
//
//  Created by Zo Rajaonarivony on 10/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import "ParkViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ParkConstant.h"
#import "ParkDetailsData.h"
#import "ParkWebServiceClient.h"
#import "ParkLocationManagerController.h"
#import "UIImage+Resizing.h"


@interface ParkViewController (){

}

@end

@implementation ParkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register Geolocation
    [self registerNotificationObserver];
    // Ask user for geolocation
    [[ParkLocationManagerController sharedLocationManager] start];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_appDelegate.mapViewWithOptions) {
        [_mapView clear];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:[NSNumber numberWithFloat:_appDelegate.preferenceData.userCurrentLatitude] forKey:@"latitude"];
        [dictionary setValue:[NSNumber numberWithFloat:_appDelegate.preferenceData.userCurrentLongitude] forKey:@"longitude"];
        
        [self startLoadingView];
        [[ParkWebServiceClient sharedInstance] startFetchingParkListWithFiltre:dictionary completionBlock:^(id completion, NSError *error) {
        //[[ParkWebServiceClient sharedInstance] startFetchingParkList:dictionary completionBlock:^(id completion, NSError *error) {
            [self stopLoadingView];
            if (!error) {
                [self FetchingListParksAroundCoordWS:completion];
            }
            else {
                [ParkUtils alertWithTitle:nil message:error.localizedDescription];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerNotificationObserver
{
    // Register Location Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCurrentUserLocationSetting:)
                                                 name:PARK_NOTIFICATION_KEY_LOCATION_UPDATED_NOTIFICATION
                                                  object:nil];
    
    // Register Location Error Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCurrentUserLocationError:)
                                                 name:PARK_NOTIFICATION_KEY_LOCATION_ERROR_NOTIFICATION
                                               object:nil];
    // Register Push Notification Observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendDeviceTokenToWS:)
                                                 name:PARK_NOTIFICATION_KEY_DEVICE_TOKEN_NOTIFICATION
                                               object:nil];
    
    // Register Popup Notification Observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCurrentUserLocationSetting:)
                                                 name:PARK_NOTIFICATION_KEY_NEW_MISSION_NOTIFICATION_FROM_PUSH
                                               object:nil];
    
}

#pragma mark - CLLocationManager Notification
- (void)updateCurrentUserLocationSetting:(NSNotification *)notification
{
    id currentLocation = [notification object];
    _appDelegate.preferenceData.geolocSmartphoneEnabled = YES;
    _appDelegate.preferenceData.userCurrentLatitude = ((CLLocation *)currentLocation).coordinate.latitude;
    _appDelegate.preferenceData.userCurrentLongitude = ((CLLocation *)currentLocation).coordinate.longitude;
   
    [[ParkLocationManagerController sharedLocationManager] stop];
    
    // Set Parameters
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithFloat:_appDelegate.preferenceData.userCurrentLatitude] forKey:@"latitude"];
    [dictionary setValue:[NSNumber numberWithFloat:_appDelegate.preferenceData.userCurrentLongitude] forKey:@"longitude"];
    
    [self startLoadingView];
    [[ParkWebServiceClient sharedInstance] startFetchingParkList:dictionary completionBlock:^(id completion, NSError *error) {
        [self stopLoadingView];
        if (!error) {
            [self FetchingListParksAroundCoordWS:completion];
        }
        else {
            [ParkUtils alertWithTitle:nil message:error.localizedDescription];
        }
    }];

}

- (void)handleCurrentUserLocationError:(NSNotification *)notification
{
    NSError *error = [notification object];
    NSLog(@"The user didn't accept the geolocation %@",error);
    if (error.code == kCLErrorDenied) {
        IGYLog(@"The user didn't accept the geolocation",error);
        _appDelegate.preferenceData.geolocSmartphoneEnabled = NO;
    }
}

- (void)FetchingListParksAroundCoordWS:(id)response
{
    NSDictionary *responseDictionary = [response copy];
    if (IS_WS_RETURNED_OK(responseDictionary)) {
        NSMutableArray *parkArray = [responseDictionary objectForKey:@"parks"];
        NSLog(@"park list %@",parkArray);
        if (_appDelegate.mapViewWithOptions){
            [self updateMapViewWithData:[self filtreData:parkArray
                                               typologie:_appDelegate.preferenceData.selectedTypologieForFiltre
                                            tarification:_appDelegate.preferenceData.selectedTarificationForFiltre]];
        }else{
            [self updateMapViewWithData:parkArray];
        }
    }
    else {
        [ParkUtils alertWithTitle:nil message:[[responseDictionary objectForKey:@"status"] objectForKey:@"Message"]];
    }
    [self stopLoadingView];
    
}

- (NSArray*)filtreData:(NSMutableArray*)parkDataArray typologie:(NSString*)typo tarification:(NSString*)tarif
{
    if (![typo isEqualToString:@"Aucun filtre"] && ![typo isEqualToString:@""]) {
        NSMutableArray *excludeMutableArray =[[NSMutableArray alloc] init];
        for (unsigned int i = 0; i < [parkDataArray count]; i++) {
            int k;
            k = 0;
            NSArray *typoArray = [[parkDataArray objectAtIndex:i] valueForKey:@"typo"];
            if ([typoArray count]!=0) {
                //check for filtre
                for (unsigned int j = 0; j < [typoArray count]; j++) {
                    if (![[[typoArray objectAtIndex:j] valueForKey:@"libelle"] isEqual:[NSNull null]]) {
                        if ([[[typoArray objectAtIndex:j] valueForKey:@"libelle"] isEqualToString:typo]) {
                            k++;
                        }
                    }
                }
                if (k<0) {
                    [excludeMutableArray addObject:[parkDataArray objectAtIndex:i]];
                }
            }else{
                [excludeMutableArray addObject:[parkDataArray objectAtIndex:i]];
            }
        }
        [parkDataArray removeObjectsInArray:excludeMutableArray];
    }
    
    if (![tarif isEqualToString:@"Aucun filtre"] && ![tarif isEqualToString:@""]) {
        NSMutableArray *excludeMutableArray =[[NSMutableArray alloc] init];
        for (unsigned int i = 0; i < [parkDataArray count]; i++) {
            int k;
            k = 0;
            NSArray *tarifArray = [[parkDataArray objectAtIndex:i] valueForKey:@"tarif"];
            if ([tarifArray count]!=0) {
                //check for filtre
                for (unsigned int j = 0; j < [tarifArray count]; j++) {
                    if (![[[tarifArray objectAtIndex:j] valueForKey:@"libelle"] isEqual:[NSNull null]]) {
                        if ([[[tarifArray objectAtIndex:j] valueForKey:@"libelle"] isEqualToString:tarif]) {
                            k++;
                        }
                    }
                }
                if (k<0) {
                    [excludeMutableArray addObject:[parkDataArray objectAtIndex:i]];
                }
            }else{
                [excludeMutableArray addObject:[parkDataArray objectAtIndex:i]];
            }
        }
        [parkDataArray removeObjectsInArray:excludeMutableArray];
    }
    
    return parkDataArray;
}

- (void)updateMapViewWithData:(NSArray*)parkDataArray{
    if ([parkDataArray count] > 0) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_appDelegate.preferenceData.userCurrentLatitude
                                                                longitude:_appDelegate.preferenceData.userCurrentLongitude
                                                                     zoom:6];
        self.mapView.camera = camera;
        self.mapView.myLocationEnabled = YES;
        
        NSLog(@"start %@",parkDataArray);
        
        NSMutableArray *excludeMutableArray =[[NSMutableArray alloc] init];
        for (unsigned int i = 0; i < [parkDataArray count]; i++) {
            ParkDetailsData *parkData = [ParkDetailsData parkFromDictionary:[parkDataArray objectAtIndex:i]];
            if (parkData) {
                if (!_appDelegate.preferenceData.morethanfour && parkData.parkFreePlaceCount >=4) {
                    [excludeMutableArray addObject:[parkDataArray objectAtIndex:i]];
                }
                if (!_appDelegate.preferenceData.morethantwo && parkData.parkFreePlaceCount <4 && parkData.parkFreePlaceCount >=2) {
                    [excludeMutableArray addObject:[parkDataArray objectAtIndex:i]];
                }
                if (!_appDelegate.preferenceData.lessthantwo && parkData.parkFreePlaceCount <2) {
                    [excludeMutableArray addObject:[parkDataArray objectAtIndex:i]];
                }
            }
        }
        NSLog(@"source %@",excludeMutableArray);
        
        NSMutableArray *filteredArray = [NSMutableArray arrayWithArray:parkDataArray];
        if (!_appDelegate.preferenceData.all) {
            [filteredArray removeObjectsInArray:excludeMutableArray];
        }
        
        for (unsigned int i = 0; i < [filteredArray count]; i++) {
            ParkDetailsData *parkData = [ParkDetailsData parkFromDictionary:[filteredArray objectAtIndex:i]];
            if (parkData) {
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(parkData.latitude,parkData.longitude);
                
                UIImage *img = nil;
                NSString *imgName =nil;
                
                if(parkData.parkFreePlaceCount < 2){
                    imgName =[NSString stringWithFormat:@"ic_moins2.png"];
                }else if(parkData.parkFreePlaceCount >= 2 && parkData.parkFreePlaceCount <4){
                    imgName =[NSString stringWithFormat:@"ic_plus2.png"];
                }else if(parkData.parkFreePlaceCount >= 4){
                    imgName =[NSString stringWithFormat:@"ic_plus4.png"];
                }
                
                img = [UIImage imageNamed:imgName];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    marker.icon = [img resizedByKeepingAspectRatio:60];
                }
                else
                {
                    marker.icon = [img resizedByKeepingAspectRatio:30];
                }
                //_mapView.mapType = kGMSTypeHybrid/*kGMSTypeTerrain*//*kGMSTypeSatellite*/;
                marker.title = parkData.parkName;
                marker.snippet = parkData.parkAddress;
                marker.map = _mapView;
            }
            parkData = nil;
        }
    }
}

#pragma mark - Push Notification Handling
- (void)sendDeviceTokenToWS:(NSNotification *)notification
{
    [[ParkWebServiceClient sharedInstance] startPostingTokenWS:(NSString *)[notification object] completionBlock:^(id completion, NSError *error) {
        if (error) {
            IGYLog(@"Error posting device token to the server :%@", error.localizedDescription)
        }
    }];
}




@end
