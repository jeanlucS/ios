//
//  PreferenceViewController.m
//  Park24
//
//  Created by Zo Rajaonarivony on 11/03/14.
//  Copyright (c) 2014 Ingenosya. All rights reserved.
//

#import "ParkPreferenceViewController.h"
#import "ParkPreferenceViewCell.h"
#import "ParkLocationManagerController.h"
#import "ParkWebServiceClient.h"


@interface ParkPreferenceViewController ()

@end

@implementation ParkPreferenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set all array here from ws
    
    [self startLoadingView];
    [[ParkWebServiceClient sharedInstance] startFetchingTypoListWithCompletionBlock:^(id completion, NSError *error) {
        if (!error) {
            NSDictionary *responseDictionary = [completion copy];
            if (IS_WS_RETURNED_OK(responseDictionary)) {
                typoParcArray= [[NSMutableArray alloc] init];
                NSMutableArray *typoParcArrayTmp= [responseDictionary objectForKey:@"typologies"];
                for (int i =0; i<[typoParcArrayTmp count]; i++) {
                    NSMutableDictionary *oneLine = [NSMutableDictionary dictionary];
                    [oneLine setValue:[[typoParcArrayTmp objectAtIndex:i] valueForKey:@"libelle"] forKey:@"libelle"];
                    [oneLine setValue:[[typoParcArrayTmp objectAtIndex:i] valueForKey:@"typologie_id"] forKey:@"id"];
                    if([[[typoParcArrayTmp objectAtIndex:i] valueForKey:@"libelle"] isEqualToString:_appDelegate.preferenceData.selectedTypologieForFiltre]){
                        [oneLine setValue:[NSNumber numberWithBool:YES] forKey:@"value"];
                    }else{
                       [oneLine setValue:[NSNumber numberWithBool:NO] forKey:@"value"];
                    }
                    
                    [typoParcArray addObject:oneLine];
                }
                NSMutableDictionary *oneLine = [NSMutableDictionary dictionary];
                [oneLine setValue:@"Aucun filtre" forKey:@"libelle"];
                [oneLine setValue:@"id" forKey:@"id"];
                if([_appDelegate.preferenceData.selectedTypologieForFiltre isEqualToString:@""] || [_appDelegate.preferenceData.selectedTypologieForFiltre isEqualToString:@"Aucun filtre"]){
                    [oneLine setValue:[NSNumber numberWithBool:YES] forKey:@"value"];
                }else{
                    [oneLine setValue:[NSNumber numberWithBool:NO] forKey:@"value"];
                }
                
                [typoParcArray addObject:oneLine];
                
                [[ParkWebServiceClient sharedInstance] startFetchingTarifListWithCompletionBlock:^(id completion, NSError *error) {
                    [self stopLoadingView];
                    if (!error) {
                        NSDictionary *TarifResponseDictionary = [completion copy];
                        if (IS_WS_RETURNED_OK(responseDictionary)) {
                            typeTarifArray= [[NSMutableArray alloc] init];
                            NSMutableArray *typeTarifArrayTmp= [TarifResponseDictionary objectForKey:@"tarification"];
                            for (int i =0; i<[typeTarifArrayTmp count]; i++) {
                                NSMutableDictionary *oneLine = [NSMutableDictionary dictionary];
                                [oneLine setValue:[[typeTarifArrayTmp objectAtIndex:i] valueForKey:@"libelle"] forKey:@"libelle"];
                                [oneLine setValue:[[typeTarifArrayTmp objectAtIndex:i] valueForKey:@"type_tarif_id"] forKey:@"id"];
                                
                                if([[[typeTarifArrayTmp objectAtIndex:i] valueForKey:@"libelle"] isEqualToString:_appDelegate.preferenceData.selectedTarificationForFiltre]){
                                    [oneLine setValue:[NSNumber numberWithBool:YES] forKey:@"value"];
                                }else{
                                    [oneLine setValue:[NSNumber numberWithBool:NO] forKey:@"value"];
                                }
                                //[oneLine setValue:[NSNumber numberWithBool:NO] forKey:@"value"];
                                
                                [typeTarifArray addObject:oneLine];
                            }
                            NSMutableDictionary *oneLine = [NSMutableDictionary dictionary];
                            [oneLine setValue:@"Aucun filtre" forKey:@"libelle"];
                            [oneLine setValue:@"id" forKey:@"id"];
                            
                            if([_appDelegate.preferenceData.selectedTarificationForFiltre isEqualToString:@""] || [_appDelegate.preferenceData.selectedTarificationForFiltre isEqualToString:@"Aucun filtre"]){
                                [oneLine setValue:[NSNumber numberWithBool:YES] forKey:@"value"];
                            }else{
                                [oneLine setValue:[NSNumber numberWithBool:NO] forKey:@"value"];
                            }
                            
                            //[oneLine setValue:[NSNumber numberWithBool:YES] forKey:@"value"];
                            [typeTarifArray addObject:oneLine];
                        }
                        else {
                            [ParkUtils alertWithTitle:nil message:[[responseDictionary objectForKey:@"status"] objectForKey:@"Message"]];
                        }
                        [self stopLoadingView];
                        [self.tablePref reloadData];
                    }
                    else {
                        [ParkUtils alertWithTitle:nil message:error.localizedDescription];
                    }
                }];
            }
            else {
                [ParkUtils alertWithTitle:nil message:[[responseDictionary objectForKey:@"status"] objectForKey:@"Message"]];
            }
            [self stopLoadingView];
        }
        else {
            [ParkUtils alertWithTitle:nil message:error.localizedDescription];
        }
    }];

    disponibilityPlaceArray = [NSArray arrayWithObjects:@"+ 4 places disponible",@"+ 2 places disponible",@"< 2 places disponible",@"Aucun filtre",nil];
    //[self startLoadingView];
    //[[ParkLocationManagerController sharedLocationManager] start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.+
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkPreferenceViewCell *cell = (ParkPreferenceViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ParkPreferenceViewCell"];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"ParkPreferenceViewCell" bundle:nil];
        cell = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        [cell.switchItem addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragInside ];
    }
    
    if (indexPath.section == 0) {
        [cell.prefItemTitle setText:[[typoParcArray objectAtIndex:indexPath.row] valueForKey:@"libelle"]];
        [cell.switchItem setOn:[[[typoParcArray objectAtIndex:indexPath.row] valueForKey:@"value"] boolValue]];
        cell.switchItem.tag=indexPath.row;
        //cell.optionButtonItem.tag=indexPath.row;
        
        return cell;
    }else if(indexPath.section==1){
        [cell.prefItemTitle setText:[[typeTarifArray objectAtIndex:indexPath.row] valueForKey:@"libelle"]];
        [cell.switchItem setOn:[[[typeTarifArray objectAtIndex:indexPath.row] valueForKey:@"value"] boolValue]];
        cell.switchItem.tag=indexPath.row+[typoParcArray count];

        return cell;
    }else if(indexPath.section==2){
        [cell.prefItemTitle setText:[disponibilityPlaceArray objectAtIndex:indexPath.row]];
        cell.switchItem.tag=indexPath.row+[typoParcArray count]+[typeTarifArray count];
        switch (indexPath.row) {
            case 0:
                [cell.switchItem setOn:[_appDelegate.preferenceData isMorethanfour]];
                break;
            case 1:
                [cell.switchItem setOn:[_appDelegate.preferenceData isMorethantwo]];
                break;
            case 2:
                [cell.switchItem setOn:[_appDelegate.preferenceData isLessthantwo]];
                break;
            case 3:
                [cell.switchItem setOn:[_appDelegate.preferenceData isAll]];
                break;
                
            default:
                break;
        }
        return cell;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"Typologie de parc";
    }else if(section==1){
        return @"Type de tarif";
    }
    else if(section==2){
        return @"Disponibilité de place";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [typoParcArray count];
    }else if(section==1){
        return [typeTarifArray count];
    }
    else if(section==2){
        return [disponibilityPlaceArray count];
    }
    return 0;
}

-(void)switchBtnClick:(id)sender
{
    UISwitch *senderSwitch = (UISwitch *)sender;
    if ((senderSwitch.isOn)) {
        //typologie
        if (senderSwitch.tag <[typoParcArray count]) {
            [[typoParcArray objectAtIndex:senderSwitch.tag] setValue:[NSNumber numberWithBool:senderSwitch.isOn] forKey:@"value"];
            _appDelegate.preferenceData.selectedTypologieForFiltre =[[typoParcArray objectAtIndex:senderSwitch.tag] valueForKey:@"libelle"];
            for (int i =0; i<[typoParcArray count]; i++) {
                if (senderSwitch.tag !=i) {
                    [[typoParcArray objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"value"];
                }
                
            }
        }
        //tarification
        else if(senderSwitch.tag >=[typoParcArray count] && senderSwitch.tag <[typoParcArray count]+[typeTarifArray count]){
            [[typeTarifArray objectAtIndex:senderSwitch.tag - [typoParcArray count]] setValue:[NSNumber numberWithBool:senderSwitch.isOn] forKey:@"value"];
            _appDelegate.preferenceData.selectedTarificationForFiltre =[[typeTarifArray objectAtIndex:senderSwitch.tag - [typoParcArray count]] valueForKey:@"libelle"];
            for (int i =0; i<[typeTarifArray count]; i++) {
                if ((senderSwitch.tag - [typoParcArray count]) !=i) {
                    [[typeTarifArray objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"value"];
                }
            }
        }
        //places
        else{
            if (senderSwitch.tag == [typoParcArray count]+[typeTarifArray count]) {
                _appDelegate.preferenceData.morethanfour =senderSwitch.isOn;
                _appDelegate.preferenceData.morethantwo =NO;
                _appDelegate.preferenceData.lessthantwo =NO;
                _appDelegate.preferenceData.all =NO;
            }else if(senderSwitch.tag == [typoParcArray count]+[typeTarifArray count]+1){
                _appDelegate.preferenceData.morethantwo =senderSwitch.isOn;
                _appDelegate.preferenceData.morethanfour =NO;
                _appDelegate.preferenceData.lessthantwo =NO;
                _appDelegate.preferenceData.all =NO;
            }else if(senderSwitch.tag == [typoParcArray count]+[typeTarifArray count]+2){
                _appDelegate.preferenceData.lessthantwo =senderSwitch.isOn;
                _appDelegate.preferenceData.morethanfour =NO;
                _appDelegate.preferenceData.morethantwo =NO;
                _appDelegate.preferenceData.all =NO;
            }else if(senderSwitch.tag == [typoParcArray count]+[typeTarifArray count]+3){
                _appDelegate.preferenceData.all =senderSwitch.isOn;
                _appDelegate.preferenceData.morethanfour =NO;
                _appDelegate.preferenceData.morethantwo =NO;
                _appDelegate.preferenceData.lessthantwo =NO;
            }
        }
    }
    [_tablePref reloadData];
}


-(IBAction)backToMapView:(UIButton *)sender
{
    _appDelegate.mapViewWithOptions = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
