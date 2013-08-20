//
//  RKHomeViewController.m
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKHomeViewController.h"

#import "RKCityListViewController.h"
#import "RKMyLohasViewController.h"
#import "RKJoinViewController.h"
#import "RKDiscountViewController.h"

@interface RKHomeViewController ()

@end

@implementation RKHomeViewController

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
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self setUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCityBtn:nil];
    [self setCityBtn2:nil];
    [self setView_ip5:nil];
    [self setView_ip4:nil];
    [super viewDidUnload];
}

#pragma mark - UI Setting
- (void)setUI {
    NSString *city =[[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    if (IS_IPHONE_5) {
        [self.view addSubview:_view_ip5];
        [self.cityBtn setTitle:city forState:UIControlStateNormal];
    }else {
        [self.view addSubview:_view_ip4];
        [self.cityBtn setTitle:city forState:UIControlStateNormal];
    }
}

- (IBAction)cityBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
        RKCityListViewController *cvCtr =[[RKCityListViewController alloc]init];
        UINavigationController *navCtr =[[UINavigationController alloc]initWithRootViewController:cvCtr];
        [self.navigationController presentViewController:navCtr animated:YES completion:nil];
}

- (IBAction)discountBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    RKDiscountViewController *dvCtr =[[RKDiscountViewController alloc]init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHCONTROLLER" object:dvCtr];
}

- (IBAction)myLohasBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    RKMyLohasViewController *mvCtr =[[RKMyLohasViewController alloc]init];
    mvCtr.viewType =myLohasType;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:mvCtr];
}

- (IBAction)joinBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
//    RKJoinViewController *jvCtr =[[RKJoinViewController alloc]init];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:jvCtr];
    
    RKMyLohasViewController *mvCtr =[[RKMyLohasViewController alloc]init];
    mvCtr.viewType =joinType;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:mvCtr];
}



@end
