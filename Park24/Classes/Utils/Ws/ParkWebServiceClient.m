//
//  WMWebServiceClient.m
//  WinMinute
//
//  Created by Zo Rajaonarivony on 29/05/13.
//  Copyright (c) 2013 WinMinute. All rights reserved.
//

#import "ParkWebServiceClient.h"

// WebService methods list
//static NSString *kWSPark = @"all_park.json";
static NSString *kWSPark = @"all_park";

//static NSString *kWSParkOptions = @"all_park_with_typologie.json";
static NSString *kWSParkOptions = @"all_park_with_typologie";
//static NSString *kWSPark = @"all_park_with_filtre";

static NSString *kWSParkInfos = @"park_infos/";
static NSString *kWSUserToken = @"user_token";
//static NSString *kWSTypoList = @"all_typologie_park.json";
//static NSString *kWSTarifList = @"all_type_tarif.json";

static NSString *kWSTypoList = @"all_typologie_park";
static NSString *kWSTarifList = @"all_type_tarif";


// Default TimeOut For NSURLRequest
static float kWSTimeOut = 120.0;

@implementation ParkWebServiceClient

#pragma mark - singleton instance

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static ParkWebServiceClient *defaultClient = nil;
    
    dispatch_once(&pred, ^{
        defaultClient = [[ParkWebServiceClient alloc] init];
    });
    return defaultClient;
}

#pragma mark - Private Methods

- (NSData *)paramToNSData:(NSDictionary *)dictionary
{
    if (dictionary) {
        NSMutableArray *paramStringArray = [[NSMutableArray alloc] init];
        for (NSString *key in dictionary) {
            NSString *pair = [NSString stringWithFormat:@"%@=%@", key, [dictionary valueForKey:key]];
            [paramStringArray addObject:pair];
        }
        NSString *string = [paramStringArray componentsJoinedByString:@"&"];
        return [string dataUsingEncoding:PARK_WS_DATA_ENCODING];
    }
    return nil;
}

// For Posting NSDictionary Object
- (void)postHttpRequest:(NSString *)wsMethod withParameter:(NSDictionary *)dictionary
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ParkUtils fullMethodUrl:wsMethod]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWSTimeOut];
    [request setHTTPMethod:@"POST"];
    
    IGYLog(@"WS Parameters:%@",dictionary)
    
    [request setHTTPBody:[self paramToNSData:dictionary]];
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                     delegate:self
                                             startImmediately:YES];
}

// no params
- (void)postHttpRequest:(NSString *)wsMethod
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ParkUtils fullMethodUrl:wsMethod]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWSTimeOut];
    [request setHTTPMethod:@"POST"];
    NSDictionary *dictionary;
    dictionary = [[NSDictionary alloc] init];
    [request setHTTPBody:[self paramToNSData:dictionary]];
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                     delegate:self
                                             startImmediately:YES];
}

// For Posting JSON Object
- (void)postHttpRequest:(NSString *)wsMethod withStringParameter:(NSString *)parameter
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ParkUtils fullMethodUrl:wsMethod]]];
    [request setHTTPMethod:@"POST"];
    
    IGYLog(@"WS Parameters:%@",parameter)
    
    // Exception For Submitting Survey Response
   /* if ([wsMethod isEqualToString:kSurveyAddResponse]) {
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    }*/
    
    NSData *data = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request
                                                     delegate:self
                                             startImmediately:YES];
}

#pragma mark - Public Methods

//Fetch Park List
- (void)startFetchingParkList:(NSDictionary*) gpsCoord completionBlock:(completionBlock)completionResult
{
    // iVar Initialisation
    _completionResult = completionResult;
    _jsonData = [[NSMutableData alloc] init];
    
    // Set Parameters
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:gpsCoord];
    
    // Create The Http Request
    [self postHttpRequest:kWSPark withParameter:dictionary];
}

//Fetch Park List with filtre
- (void)startFetchingParkListWithFiltre:(NSDictionary*) parameters completionBlock:(completionBlock) completionResult
{
    // iVar Initialisation
    _completionResult = completionResult;
    _jsonData = [[NSMutableData alloc] init];
    
    // Set Parameters
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:parameters];
 
     // Create The Http Request
     [self postHttpRequest:kWSParkOptions withParameter:dictionary];
}

- (void)startFetchingSelectedParkInfos:(NSDictionary*) parameters completionBlock:(completionBlock) completionResult
{
    // iVar Initialisation
    _completionResult = completionResult;
    _jsonData = [[NSMutableData alloc] init];
    
    // Set Parameters
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    // Create The Http Request
    [self postHttpRequest:kWSParkInfos withParameter:dictionary];
}

/** WS Post Device Token
 
 @param
 @return
 */
- (void)startPostingTokenWS:(NSString *)token completionBlock:(completionBlock )completionResult
{
    // iVar Initialisation
    _completionResult = completionResult;
    _jsonData = [[NSMutableData alloc] init];
    
    // Set Parameters
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:token forKey:@"token"];
    
    // Create The Http Request
    [self postHttpRequest:kWSUserToken withParameter:dictionary];
    
}

- (void)startFetchingTypoListWithCompletionBlock:(completionBlock )completionResult{
    // iVar Initialisation
    _completionResult = completionResult;
    _jsonData = [[NSMutableData alloc] init];
    
    // Create The Http Request
    [self postHttpRequest:kWSTypoList];
}

- (void)startFetchingTarifListWithCompletionBlock:(completionBlock )completionResult{
    // iVar Initialisation
    _completionResult = completionResult;
    _jsonData = [[NSMutableData alloc] init];
    
    // Create The Http Request
    [self postHttpRequest:kWSTarifList];
}

#pragma mark - Connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *data = [[NSString alloc] initWithData:_jsonData encoding:NSASCIIStringEncoding];
    IGYLog(@"Data:%@",data)
    if (_jsonData) {
        NSError *error = nil;
        NSDictionary *wsResultDic = [NSJSONSerialization JSONObjectWithData:_jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            IGYLog(@"Error Occured While Fetchind Data:%@",error)
        }
        
        IGYLog(@"WS Response : %@", wsResultDic);
        self.completionResult(wsResultDic, nil);
    }
    else {
        NSLog(@"No Data Retrieved");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    switch (error.code) {
        case NSURLErrorTimedOut:
            // Timeout Reached, Handle It
            IGYLog(@"Time Out Reached")
            break;
        case kCFURLErrorCannotConnectToHost:
            // Server Unreachable
            IGYLog(@"Server Not Found")
            break;
        case kCFURLErrorNetworkConnectionLost:
            IGYLog(@"Connection Lost")
            break;
        default:
            break;
    }
    self.completionResult(nil, error);
}

@end
