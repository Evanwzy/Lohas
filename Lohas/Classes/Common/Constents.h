//
//  Constents.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

//Server Address
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#define SERVER_URL @"http://192.168.1.5/lehuo/index.php?s="
#define SERVER_URL @"http://lehuo.d23684.51kweb.com/lehuo/index.php?s="


//Url Address
#define RegisterUrl [NSString stringWithFormat:@"%@/ApiLogin/register", SERVER_URL]
#define CheckAccountUrl [NSString stringWithFormat:@"%@/ApiSend/register_send", SERVER_URL]
#define CheckStoreAccountUrl [NSString stringWithFormat:@"%@/ApiSend/store_send", SERVER_URL]
#define LoginUrl [NSString stringWithFormat:@"%@/ApiLogin/login", SERVER_URL]
#define joinUrl [NSString stringWithFormat:@"%@/ApiJoin/join", SERVER_URL]
#define getCertifitionUrl [NSString stringWithFormat:@"%@/ApiJoin/get_result", SERVER_URL]
#define discountUrl [NSString stringWithFormat:@"%@/ApiDiscount/discount_list", SERVER_URL]
#define shopInfoUrl [NSString stringWithFormat:@"%@/ApiJoin/join_info", SERVER_URL]
