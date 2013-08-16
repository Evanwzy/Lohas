//
//  RKMyLohasViewController.m
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKMyLohasViewController.h"

#import "RKRegisterViewController.h"

@interface RKMyLohasViewController ()

@end

@implementation RKMyLohasViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setView_ip5:nil];
    [self setView_ip4:nil];
    [self setAccountText_ip4:nil];
    [self setPwdText_ip4:nil];
    [self setAccountText_ip5:nil];
    [self setPwdText_ip5:nil];
    [self setLoginedView_ip5:nil];
    [self setLoginedView_ip4:nil];
    [self setNameLabel_ip4:nil];
    [self setNameLabel_ip5:nil];
    [super viewDidUnload];
}

#pragma mark - UI Setting
- (void)setupUI {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"IsLogined"]) {
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
        if (IS_IPHONE_5) {
            self.nameLabel_ip5.text = [userInfo objectForKey:@"name"];
            [self.view addSubview:self.loginedView_ip5];
        } else {
            
            self.nameLabel_ip4.text = [userInfo objectForKey:@"name"];
            [self.view addSubview:self.loginedView_ip4];
        }
    }else {
        if (IS_IPHONE_5) {
            [self.view addSubview:self.view_ip5];
        } else {
            [self.view addSubview:self.view_ip4];
        }
    }
}

#pragma mark - button Action

- (IBAction)LoginBtnPressed:(id)sender {
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    manager.loginDelagate =self;
    NSString *accountStr;
    NSString *pwdStr;
    if (IS_IPHONE_5) {
        if ([self.accountText_ip5.text isEqual:@""] && [self.pwdText_ip5.text isEqual:@""]) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else {
            accountStr    =self.accountText_ip5.text;
            pwdStr        =self.pwdText_ip5.text;
        }
        
    } else {
        if ([self.accountText_ip4.text isEqual:@""] && [self.pwdText_ip4.text isEqual:@""]) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else {
            accountStr    =self.accountText_ip4.text;
            pwdStr        =self.pwdText_ip4.text;
        }
    }
    [manager loginWithAccount:accountStr AndPwd:pwdStr];
    
}

- (IBAction)RegisterBtnPressed:(id)sender {
    RKRegisterViewController *rvCtr =[[RKRegisterViewController alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:rvCtr];
}

- (IBAction)ForgetBtnPressed:(id)sender {
}

- (IBAction)backBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPCONTROLLER" object:nil];
}

- (IBAction)loginOutBtn:(id)sender {
}
@end