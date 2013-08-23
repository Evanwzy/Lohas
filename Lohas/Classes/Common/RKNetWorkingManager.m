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

@synthesize registerDelagate, loginDelagate, joinLohasDelegate, certificationDataDelegate, discountDelegate, detailDelegate;

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
//    NSLog(@"%@", [request responseString]);
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

- (void)checkStoreWithAccount:(NSString *)accountStr {
    [self checkQueue];
    
    NSURL *url =[NSURL URLWithString:CheckStoreAccountUrl];
    
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request addPostValue:accountStr forKey:@"store_phone"];
    [request addPostValue:[Common getKey] forKey:@"user_key"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(checkAccountFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    
    request.timeOutSeconds=10;
    
    [queue addOperation:request];
}

- (void)checkAccountFinished :(ASIHTTPRequest *)request {
//    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENDREFRASH" object:nil];
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
//    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"IsLogined"];
        [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:@"data"] forKey:@"UserInfo"];
        [loginDelagate getLoginResult];
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENDREFRASH" object:nil];
    }
}

//join Lohas
-(void)joinLohasWithName:(NSString *)nameStr Account:(NSString *)accountStr ownerAccount:(NSString *)ownerAcc Verify:(NSString *)verifyStr Kind:(NSString *)kindStr Site:(NSString *)site Latitude:(NSString *)latitudeStr Longitude:(NSString *)longitudeStr Address:(NSString *)addressStr Doorphoto:(UIImage *)doorImg Date:(NSString *)dateStr ShopKind:(NSString *)shopkind Certificatephoto:(UIImage *)certificateImg PeopleInCharge:(NSString *)peoInCharge Ctiy:(NSString *)city {
    [self checkQueue];
    
    NSURL *url =[NSURL URLWithString:joinUrl];
    NSString *doorImgPath =[Common pathForImage:@"1.jpg"];
    NSString *certificateImgPath =[Common pathForImage:@"2.jpg"];
    
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    [request addPostValue:nameStr forKey:@"store_name"];
    [request addPostValue:accountStr forKey:@"account"];
    [request addPostValue:ownerAcc forKey:@"store_phone"];
    [request addPostValue:verifyStr forKey:@"verify"];
    [request addPostValue:kindStr forKey:@"trade"];
    [request addPostValue:site forKey:@"estate"];
    [request addPostValue:latitudeStr forKey:@"lat"];
    [request addPostValue:longitudeStr forKey:@"lng"];
    [request addPostValue:addressStr forKey:@"address"];
    [request addFile:doorImgPath withFileName:@"1.jpg" andContentType:@"image/jpg" forKey:@"store_pic"];
    [request addPostValue:dateStr forKey:@"start_business"];
    [request addPostValue:shopkind forKey:@"classification"];
    [request addFile:certificateImgPath withFileName:@"2.jpg" andContentType:@"image/jpg" forKey:@"licence_pic"];
    [request addPostValue:peoInCharge forKey:@"official"];
    [request addPostValue:city forKey:@"city"];
    [request addPostValue:[Common getKey] forKey:@"user_key"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(joinLohasFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    
    request.timeOutSeconds=10;
    
    [queue addOperation:request];
    
}

- (void)joinLohasFinished:(ASIHTTPRequest *)request {
//    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
        [Common showNetWorokingAlertWithMessageWithSucc:[data objectForKey:@"msg"]];           
        [joinLohasDelegate getjoinLohasResult];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"COMMITENABLE" object:nil];
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENDREFRASH" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"COMMITENABLE" object:nil];
    }
}

//get certifition data
- (void) getCertifitionDataWithLatitude:(NSString *)latitude Longitude:(NSString *)longitude distance:(NSString *)distance kind:(NSString *)kind {
    [self checkQueue];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/&lng=%@&lat=%@&distance=%@&trade=%@", getCertifitionUrl, longitude, latitude, distance, kind]];
    
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getCertifitionDataFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    [queue addOperation:request];
    
}

- (void) getCertifitionDataFinished :(ASIHTTPRequest *)request {
//    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
        [certificationDataDelegate certificationData:[data objectForKey:@"data"]];
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENDREFRASH" object:nil];
    }
}

//get city discount data
- (void) getDiscountData:(NSString *)cityName {
    [self checkQueue];
    
    NSURL *url = [NSURL URLWithString:discountUrl];
    
    ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:url];
    
    [request addPostValue:cityName forKey:@"city"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getDiscountDataFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    [queue addOperation:request];
}


- (void) getDiscountDataFinished :(ASIHTTPRequest *)request {
    //    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
        NSArray *arr =[data objectForKey:@"data"];
        [discountDelegate discountData:arr];
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENDREFRASH" object:nil];
    }
}

//get detail data
-(void)getdetailData:(NSString *)shopID {
    [self checkQueue];
    
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@/&id=%@", shopInfoUrl, shopID]];
    
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
//    [request addPostValue:shopID forKey:@"id"];
//    [request addPostValue:[Common getKey] forKey:@"user_key"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getdetailDataFinished:)];
    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
    
    request.timeOutSeconds=10;
    
    [queue addOperation:request];
    
}

- (void)getdetailDataFinished:(ASIHTTPRequest *)request {
    //    NSLog(@"%@", [request responseString]);
    NSDictionary *data =[[request responseString] JSONValue];
    if ([[data objectForKey:@"status"] isEqual:@"0"]) {
        [detailDelegate detailData:[[data objectForKey:@"data"] objectAtIndex:0]];
    } else {
        [Common showNetWorokingAlertWithMessage:[data objectForKey:@"msg"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENDREFRASH" object:nil];
    }
}

//-(void)netTest {
//    [self checkQueue];
//    
//    NSURL *url =[NSURL URLWithString:@"http://192.168.1.103/lehuo/index.php?s=/ApiMessage/demo"];
//    
//    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
//    
//    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(testFinished:)];
//    [request setDidFailSelector:@selector(commonRequestQueryDataFailed:)];
//    [queue addOperation:request];
//    
//}
//
//- (void) testFinished :(ASIHTTPRequest *)request {
//    //    NSLog(@"%@", [request responseString]);
//    NSMutableDictionary *dataDict =[[NSMutableDictionary alloc]init];
//    NSArray *data =[[request responseString] JSONValue];
//    
//    for (int i =0; i<[data count]; i++) {
//        NSDictionary *dict =[data objectAtIndex:i];
//        [dataDict setValue:[dict objectForKey:@"name"] forKey:[dict objectForKey:@"id"]];
//    }
//    
//    NSArray *doc = NSSearchPathForDirectoriesInDomains(
//                                                       
//                                                       NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *docPath = [ doc objectAtIndex:0 ];
//    
//    NSString *docLocation=[docPath
//                           
//                           stringByAppendingPathComponent:[NSString stringWithFormat:@"city.plist"]];
//    [dataDict writeToFile:docLocation atomically:YES];
//}

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
                                                        message:@"联网失败，请检查网络"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENDREFRASH" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COMMITENABLE" object:nil];
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