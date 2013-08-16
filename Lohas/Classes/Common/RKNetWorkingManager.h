//
//  RKNetWorkingManager.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "Constents.h"

@protocol RKNetWorkingManagerRegisterDelegate;
@protocol RKNetWorkingManagerLoginDelegate;

@interface RKNetWorkingManager : NSObject {
    ASINetworkQueue *queue;
    ASINetworkQueue *singleQueue;
    ASINetworkQueue *remoteNotificationQueue;
    //NSOperationQueue *queue;
    
    //NetWorkingRequestDelegate
    id<RKNetWorkingManagerRegisterDelegate> registerDelegate;
}

@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) ASINetworkQueue *singleQueue;
@property (nonatomic, retain) ASINetworkQueue *remoteNotificationQueue;

@property (nonatomic, assign) id<RKNetWorkingManagerRegisterDelegate> registerDelagate;
@property (nonatomic, assign) id<RKNetWorkingManagerLoginDelegate> loginDelagate;

+ (RKNetWorkingManager *)sharedManager;

//upload Request
- (void) registerWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr AndName:(NSString *)nameStr;
- (void) loginWithAccount:(NSString *)accountStr AndPwd:(NSString *)pwdStr;


@end

@protocol RKNetWorkingManagerRegisterDelegate <NSObject>

- (void) getRegisterResult;

@end

@protocol RKNetWorkingManagerLoginDelegate <NSObject>

- (void) getLoginResult;

@end
