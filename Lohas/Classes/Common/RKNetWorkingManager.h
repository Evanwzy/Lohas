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
@protocol RKNetWorkingManagerCertifitionDataDelegate;
@protocol RKNetWorkingManagerDiscountDelegate;
@protocol RKNetWorkingManagerDetailDelegate;

@interface RKNetWorkingManager : NSObject {
    ASINetworkQueue *queue;
    ASINetworkQueue *singleQueue;
    ASINetworkQueue *remoteNotificationQueue;
    //NSOperationQueue *queue;
    
    //NetWorkingRequestDelegate
    id<RKNetWorkingManagerRegisterDelegate> registerDelegate;
    id<RKNetWorkingManagerLoginDelegate> loginDelagate;
    id<RKNetWorkingManagerJoinLohasDelegate> joinLohasDelegate;
    id<RKNetWorkingManagerCertifitionDataDelegate> certificationDataDelegate;
    id<RKNetWorkingManagerDiscountDelegate> discountDelegate;
    id<RKNetWorkingManagerDetailDelegate> detailDelegate;
}

@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) ASINetworkQueue *singleQueue;
@property (nonatomic, retain) ASINetworkQueue *remoteNotificationQueue;

@property (nonatomic, assign) id<RKNetWorkingManagerRegisterDelegate> registerDelagate;
@property (nonatomic, assign) id<RKNetWorkingManagerLoginDelegate> loginDelagate;
@property (nonatomic, assign) id<RKNetWorkingManagerJoinLohasDelegate> joinLohasDelegate;
@property (nonatomic, assign) id<RKNetWorkingManagerCertifitionDataDelegate> certificationDataDelegate;
@property (nonatomic, assign) id<RKNetWorkingManagerDiscountDelegate> discountDelegate;
@property (nonatomic, assign) id<RKNetWorkingManagerDetailDelegate> detailDelegate;

+ (RKNetWorkingManager *)sharedManager;

//upload Request
- (void) netTest;

- (void) registerWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr AndName:(NSString *)nameStr AndVerify:(NSString *)verifyStr;
- (void) checkWithAccount:(NSString *)accountStr;
- (void) checkStoreWithAccount:(NSString *)accountStr;
- (void) loginWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr;
- (void) joinLohasWithName:(NSString *)nameStr Account:(NSString *)accountStr ownerAccount:(NSString *)ownerAcc Verify:(NSString *)verifyStr Kind:(NSString *)kindStr Site:(NSString *)site Latitude:(NSString *)latitudeStr Longitude:(NSString *)longitudeStr Address:(NSString *)addressStr Doorphoto:(UIImage *)doorImg Date:(NSString *)dateStr ShopKind:(NSString *)shopkind Certificatephoto:(UIImage *)certificateImg PeopleInCharge:(NSString *)peoInCharge Ctiy:(NSString *)city;

//get Request
- (void) getCertifitionDataWithLatitude:(NSString *)latitude Longitude:(NSString *)longitude distance:(NSString *)distance kind:(NSString *)kind;
- (void) getDiscountData:(NSString *)cityName;
- (void) getdetailData:(NSString *)shopID;

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

@protocol RKNetWorkingManagerCertifitionDataDelegate <NSObject>

- (void) certificationData:(NSArray *)dataArray;

@end

@protocol RKNetWorkingManagerDiscountDelegate <NSObject>

- (void) discountData:(NSArray *)dataArray;

@end

@protocol RKNetWorkingManagerDetailDelegate <NSObject>

- (void) detailData:(NSDictionary *)dataDict;

@end
