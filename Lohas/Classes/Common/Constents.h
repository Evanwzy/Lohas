//
//  Constents.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

//Server Address
#define SERVER_URL @"http://192.168.1.103/lehuo/index.php?s="


//Url Address
#define RegisterUrl [NSString stringWithFormat:@"%@/ApiLogin/register", SERVER_URL]
#define CheckAccountUrl [NSString stringWithFormat:@"%@/ApiLogin/sendSHP", SERVER_URL]
#define LoginUrl [NSString stringWithFormat:@"%@/ApiLogin/login", SERVER_URL]
#define joinUrl [NSString stringWithFormat:@"%@/ApiJoin/join", SERVER_URL]
#define getCertifitionUrl [NSString stringWithFormat:@"%@/ApiJoin/get_result", SERVER_URL]