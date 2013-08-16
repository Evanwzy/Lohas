//
//  RKCityListViewController.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Common.h"

@interface RKCityListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)NSDictionary *cityDict;
@property (nonatomic, retain)NSArray *valueArr;
@property (nonatomic, retain)NSArray *keyArr;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITableView *tableView2;

- (IBAction)backBtn:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *view_ip4;
@property (strong, nonatomic) IBOutlet UIView *view_ip5;
@end
