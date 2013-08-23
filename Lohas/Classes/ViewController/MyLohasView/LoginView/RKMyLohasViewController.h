//
//  RKMyLohasViewController.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

typedef enum {
    myLohasType =0,
    joinType
}LOGINTYPE;

#import <UIKit/UIKit.h>
#import "Common.h"
#import "RKNetWorkingManager.h"
#import "UIKeyboardViewController.h"

@interface RKMyLohasViewController : UIViewController <UIKeyboardViewControllerDelegate, RKNetWorkingManagerLoginDelegate> {
    
    UIKeyboardViewController *keyBoardController;
}
@property int viewType;

@property (strong, nonatomic) IBOutlet UIView *view_ip5;
@property (strong, nonatomic) IBOutlet UIView *view_ip4;
@property (strong, nonatomic) IBOutlet UIView *loginedView_ip5;
@property (strong, nonatomic) IBOutlet UIView *loginedView_ip4;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel_ip4;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel_ip5;


@property (weak, nonatomic) IBOutlet UITextField *accountText_ip4;
@property (weak, nonatomic) IBOutlet UITextField *pwdText_ip4;
@property (weak, nonatomic) IBOutlet UITextView *infoText_ip4;
@property (weak, nonatomic) IBOutlet UITextField *accountText_ip5;
@property (weak, nonatomic) IBOutlet UITextField *pwdText_ip5;
@property (weak, nonatomic) IBOutlet UITextView *infoText_ip5;

- (IBAction)LoginBtnPressed:(id)sender;
- (IBAction)RegisterBtnPressed:(id)sender;
- (IBAction)ForgetBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)loginOutBtn:(id)sender;

@end
