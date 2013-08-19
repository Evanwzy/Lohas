//
//  RKRegisterViewController.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "RKNetWorkingManager.h"
#import "UIKeyboardViewController.h"

@interface RKRegisterViewController : UIViewController <RKNetWorkingManagerRegisterDelegate, UIKeyboardViewControllerDelegate> {
    UIKeyboardViewController *keyBoardController;
}


@property (strong, nonatomic) IBOutlet UIView *view_ip5;
@property (strong, nonatomic) IBOutlet UIView *view_ip4;

@property (weak, nonatomic) IBOutlet UITextField *accountText_ip5;
@property (weak, nonatomic) IBOutlet UITextField *pwdText_ip5;
@property (weak, nonatomic) IBOutlet UITextField *nameText_ip5;
@property (weak, nonatomic) IBOutlet UITextField *verifyText_ip5;

@property (weak, nonatomic) IBOutlet UITextField *accountText_ip4;
@property (weak, nonatomic) IBOutlet UITextField *pwdText_ip4;
@property (weak, nonatomic) IBOutlet UITextField *nameText_ip4;
@property (weak, nonatomic) IBOutlet UITextField *verifyText_ip4;

- (IBAction)registerBtnPressed:(UIButton *)sender;

- (IBAction)backBtnPressed:(id)sender;

- (IBAction)checkBtnPressed:(id)sender;

@end
