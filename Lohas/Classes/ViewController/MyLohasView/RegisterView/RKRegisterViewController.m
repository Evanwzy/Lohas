//
//  RKRegisterViewController.m
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKRegisterViewController.h"

@interface RKRegisterViewController ()


@end

@implementation RKRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    
    
    [keyBoardController addToolbarToKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setView_ip5:nil];
    [self setView_ip4:nil];
    [self setAccountText_ip5:nil];
    [self setPwdText_ip5:nil];
    [self setNameText_ip5:nil];
    [self setAccountText_ip4:nil];
    [self setPwdText_ip4:nil];
    [self setNameText_ip4:nil];
    [self setVerifyText_ip5:nil];
    [self setVerifyText_ip4:nil];
    [self setCheckBtn_ip4:nil];
    [self setCheckBtn_ip5:nil];
    [super viewDidUnload];
}

#pragma mark - UI Setting
- (void)setupUI {
    if (IS_IPHONE_5) {
        [self.view addSubview:self.view_ip5];
    } else {
        [self.view addSubview:self.view_ip4];
    }
}

#pragma mark - Button Action
- (IBAction)registerBtnPressed:(UIButton *)sender {
    if (IS_IPHONE_5) {
        if ([self.accountText_ip5.text isEqualToString:@""] && [self.pwdText_ip5.text isEqual:@""] &&[self.nameText_ip5.text isEqual:@""] &&[self.verifyText_ip5.text isEqual:@""]) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else {
            [self registerRequest:self.accountText_ip5.text :self.pwdText_ip5.text :self.nameText_ip5.text :self.verifyText_ip5.text];
        }
    } else {
        if ([self.accountText_ip4.text isEqualToString:@""] && [self.pwdText_ip4 isEqual:@""] &&[self.nameText_ip4.text isEqual:@""] &&[self.verifyText_ip4.text isEqual:@""]) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else {
            [self registerRequest:self.accountText_ip4.text :self.pwdText_ip4.text :self.nameText_ip4.text :self.verifyText_ip4.text];
        }
    }
}

- (IBAction)backBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POPCONTROLLER" object:nil];
}

- (IBAction)checkBtnPressed:(id)sender {
    if (IS_IPHONE_5) {
        if (self.accountText_ip5.text.length ==0) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else {
            [self checkAccountRequest:self.accountText_ip5.text];
            [self.checkBtn_ip5 setTitle:@"请等待" forState:UIControlStateNormal];
            self.checkBtn_ip5.userInteractionEnabled =NO;
            [self performSelector:@selector(checkBtnUI) withObject:nil afterDelay:30.0f];
        }
    } else {
        if (self.accountText_ip4.text.length ==0) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else {
            [self checkAccountRequest:self.accountText_ip4.text];
            [self.checkBtn_ip4 setTitle:@"请等待" forState:UIControlStateNormal];
            self.checkBtn_ip4.userInteractionEnabled =NO;
            [self performSelector:@selector(checkBtnUI) withObject:nil afterDelay:30.0f];
        }
    }
}

- (void)checkBtnUI{
    if (IS_IPHONE_5) {
        [self.checkBtn_ip5 setTitle:@"获取验证" forState:UIControlStateNormal];
        self.checkBtn_ip5.userInteractionEnabled =YES;
    } else {
        [self.checkBtn_ip5 setTitle:@"获取验证" forState:UIControlStateNormal];
        self.checkBtn_ip5.userInteractionEnabled =YES;
    }
}

#pragma mark - Http Request Method

- (void)registerRequest:(NSString *)accountStr :(NSString *)pwdStr :(NSString *)nameStr :(NSString *)verifyStr{
//    if (IS_IPHONE_5) {
//        self.accountText_ip5.text =@"";
//        self.pwdText_ip5.text =@"";
//        self.nameText_ip5.text =@"";
//        self.verifyText_ip5.text =@"";
//    } else {
//        self.accountText_ip4.text =@"";
//        self.pwdText_ip4.text =@"";
//        self.nameText_ip4.text =@"";
//        self.verifyText_ip4.text =@"";
//    }
    [Common cancelAllRequestOfAllQueue];
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    manager.registerDelagate =self;
    [manager registerWithAccount:accountStr AndPwd:pwdStr AndName:nameStr AndVerify:verifyStr];
}

- (void)checkAccountRequest:(NSString *)accountStr {
    [Common cancelAllRequestOfAllQueue];
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    [manager checkWithAccount:accountStr];
}

- (void)getRegisterResult {
    [self backBtnPressed:nil];
}


#pragma mark - UIKeyboardViewController delegate methods



- (void)alttextFieldDidEndEditing:(UITextField *)textField {
    
    
}

-(void)alttextFieldDidBeginEditing:(UITextField *)textField {
    
}
@end
