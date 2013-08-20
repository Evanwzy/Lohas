//
//  RKNetWorkingManager.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "Constents.h"

@protocol RKNetWorkingManagerRegisterDelegate;
@protocol RKNetWorkingManagerLoginDelegate;
@protocol RKNetWorkingManagerJoinLohasDelegate;

@interface RKNetWorkingManager : NSObject {
    ASINetworkQueue *queue;
    ASINetworkQueue *singleQueue;
    ASINetworkQueue *remoteNotificationQueue;
    //NSOperationQueue *queue;
    
    //NetWorkingRequestDelegate
    id<RKNetWorkingManagerRegisterDelegate> registerDelegate;
    id<RKNetWorkingManagerLoginDelegate> loginDelagate;
    id<RKNetWorkingManagerJoinLohasDelegate> joinLohasDelegate;
}

@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) ASINetworkQueue *singleQueue;
@property (nonatomic, retain) ASINetworkQueue *remoteNotificationQueue;

@property (nonatomic, assign) id<RKNetWorkingManagerRegisterDelegate> registerDelagate;
@property (nonatomic, assign) id<RKNetWorkingManagerLoginDelegate> loginDelagate;
@property (nonatomic, assign) id<RKNetWorkingManagerJoinLohasDelegate> joinLohasDelegate;

+ (RKNetWorkingManager *)sharedManager;

//upload Request
- (void) registerWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr AndName:(NSString *)nameStr AndVerify:(NSString *)verifyStr;
- (void) checkWithAccount:(NSString *)accountStr;
- (void) loginWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr;
- (void) joinLohasWithName:(NSString *)nameStr Account:(NSString *)accountStr Kind:(NSString *)kindStr Site:(NSString *)site Latitude:(NSString *)latitudeStr Longitude:(NSString *)longitudeStr Address:(NSString *)addressStr Doorphoto:(UIImage *)doorImg Date:(NSString *)dateStr ShopKind:(NSString *)shopkind Certificatephoto:(UIImage *)certificateImg PeopleInCharge:(NSString *)peoInCharge Ctiy:(NSString *)city;

//get Request
- (void) getCertifitionDataWithLatitude:(NSString *)latitude Longitude:(NSString *)longitude distance:(NSString *)distance kind:(NSString *)kind;

@end

@protocol RKNetWorkingManagerRegisterDelegate <NSObject>

- (void) getRegisterResult;

@end

@protocol RKNetWorkingManagerLoginDelegate <NSObject>

- (void) getLoginResult;

@end

@protocol RKNetWorkingManagerJoinLohasDelegate <NSObject>

- (void) getjoinLohasResult;

@end
