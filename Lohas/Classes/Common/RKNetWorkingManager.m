//
//  RKNetWorkingManager.m
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKNetWorkingManager.h"
#import "SBJson.h"
#import "Common.h"

#define NETWORK_QUEUE_CURRENT_OPERATION 1

@implementation RKNetWorkingManager
@synthesize queue;
@synthesize singleQueue;

@synthesize registerDelagate, loginDelagate;

#pragma - singleton

static RKNetWorkingManager *_networkRequestManager;

+(RKNetWorkingManager *)sharedManager {
    @synchronized(self){
        if (_networkRequestManager == nil) {
            _networkRequestManager = [[self alloc]init];
        }
    }
    return _networkRequestManager;
}

#pragma mark - NetWorkingRequest

//User Register
- (void)registerWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr AndName:(NSString *)nameStr AndVerify:(NSString *)verifyStr {
    [self checkQueue];
    
    NSURL *url =[NSURL URLWithString:RegisterUrl];
    
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request addPostValue:accountStr forKey:@"account"];
    [request addPostValue:pwdStr forKey:@"password"];
    [request addPostValue:nameStr forKey:@"name"];
    [request addPostValue:verifyStr forKey:@"verify"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(registerFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    
    request.timeOutSeconds=10;
    
    [queue addOperation:request];
}

- (void)registerFinished :(ASIHTTPRequest *)request {
    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
        [registerDelagate getRegisterResult];
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
    }
}

//Check Account
- (void)checkWithAccount:(NSString *)accountStr {
    [self checkQueue];
    
    NSURL *url =[NSURL URLWithString:CheckAccountUrl];
    
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request addPostValue:accountStr forKey:@"telephone"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(checkAccountFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    
    request.timeOutSeconds=10;
    
    [queue addOperation:request];
}

- (void)checkAccountFinished :(ASIHTTPRequest *)request {
    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
    }
}

//User Login
- (void)loginWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr {
    [self checkQueue];
    
    NSURL *url =[NSURL URLWithString:LoginUrl];
    
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request addPostValue:accountStr forKey:@"account"];
    [request addPostValue:pwdStr forKey:@"password"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(loginFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    
    request.timeOutSeconds=10;
    
    [queue addOperation:request];
}

- (void)loginFinished :(ASIHTTPRequest *)request {
    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"IsLogined"];
        [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:@"data"] forKey:@"UserInfo"];
        [loginDelagate getLoginResult];
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
    }
}

//join Lohas
-(void)joinLohasWithAccount:(NSString *)accountStr Kind:(NSString *)kindStr Site:(NSString *)site Location:(NSString *)locationStr Latitude:(NSString *)latitudeStr Longitude:(NSString *)longitudeStr Doorphoto:(UIImage *)doorImg Date:(NSString *)dateStr ShopKind:(NSString *)shopkind Certificatephoto:(UIImage *)certificateImg PeopleInCharge:(NSString *)peoInCharge {
    [self checkQueue];
    
    NSURL *url =[NSURL URLWithString:LoginUrl];
    NSData *doorImgData =UIImageJPEGRepresentation(doorImg, 1.0);
    NSData *certificateImgData =UIImageJPEGRepresentation(certificateImg, 1.0);
    
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request addData:doorImgData forKey:@""];
    [request addData:certificateImgData forKey:@""];
    [request addPostValue:accountStr forKey:@"account"];
    request addPostValue:<#(id<NSObject>)#> forKey:<#(NSString *)#>
    
}

#pragma mark - Common methods
-(void)checkQueue{
    if (!queue) {
        queue = [[ASINetworkQueue alloc]init];
        [queue setMaxConcurrentOperationCount:NETWORK_QUEUE_CURRENT_OPERATION];
        [queue setShouldCancelAllRequestsOnFailure:NO];
        
        [queue go];
    }
}

-(void)checkSingleQueue{
    if (!singleQueue) {
        singleQueue = [[ASINetworkQueue alloc]init];
        [singleQueue setMaxConcurrentOperationCount:NETWORK_QUEUE_CURRENT_OPERATION];
        [singleQueue setShouldCancelAllRequestsOnFailure:NO];
        [singleQueue go];
    }
}

-(void)checkRemoteNotificationQueue{
    if (!remoteNotificationQueue) {
        remoteNotificationQueue = [[ASINetworkQueue alloc] init];
        [remoteNotificationQueue setMaxConcurrentOperationCount:NETWORK_QUEUE_CURRENT_OPERATION];
        [remoteNotificationQueue setShouldCancelAllRequestsOnFailure:NO];
        [remoteNotificationQueue go];
    }
}

- (void)commonRequestQueryDataFailed:(ASIHTTPRequest *)request {
    //new code 11.30 ???
    //    NSString *where = [request.userInfo objectForKey:@"where"];
    //    if ([where isEqualToString:@"shanghai"] || [where isEqualToString:@"banner"] || [where isEqualToString:@"shSub"]) {
    //        if (!shouldShowAlertAtHome) {
    //            return;
    //        } else {
    //            shouldShowAlertAtHome = NO;
    //        }
    //    }
    //
    //    //old code...
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"本次更新失败，请检查网络"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    NSLog(@"query data error: %@", [request error]);
}

- (void)dealloc {
    if (queue) {
        [queue cancelAllOperations];
        [queue release];
    }
    
    if (remoteNotificationQueue) {
        [remoteNotificationQueue cancelAllOperations];
        [remoteNotificationQueue release];
    }
    
    if(singleQueue){
        [singleQueue cancelAllOperations];
        [singleQueue release];
    }
    
    [super dealloc];
}

#pragma mark - Common cancel

- (void)cancelAll{
    for (ASIHTTPRequest *request in [queue operations]) {
        [request cancel];
    }
}
@end