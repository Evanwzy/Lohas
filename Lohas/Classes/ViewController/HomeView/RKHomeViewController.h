//
//  RKHomeViewController.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Common.h"

@interface RKHomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *view_ip5;
@property (strong, nonatomic) IBOutlet UIView *view_ip4;

@property (retain, nonatomic) IBOutlet UIButton *cityBtn;
@property (retain, nonatomic) IBOutlet UIButton *cityBtn2;

- (IBAction)cityBtnPressed:(id)sender;
- (IBAction)myLohasBtnPressed:(id)sender;
- (IBAction)joinBtnPressed:(id)sender;


@end
