//
//  RKDiscountViewController.h
//  Lohas
//
//  Created by Evan on 13-8-19.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Common.h"

#import "RKDiscountCell.h"

@interface RKDiscountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *view_ip5;
@property (strong, nonatomic) IBOutlet UIView *view_ip4;

@property (weak, nonatomic) IBOutlet UITableView *tableView_ip5;
@property (weak, nonatomic) IBOutlet UITableView *tableView_ip4;

@property (retain, nonatomic) NSArray *dataArr;

- (IBAction)backBtnPressed:(id)sender;

@end
