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
    
    //set IsLogined Value
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"IsLogined"];
    
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
    if (IS_IPHONE_5) {
        [self.view addSubview:_view_ip5];
    }else {
        [self.view addSubview:_view_ip4];
    }
}

- (IBAction)cityBtnPressed:(id)sender {
        RKCityListViewController *cvCtr =[[RKCityListViewController alloc]init];
        UINavigationController *navCtr =[[UINavigationController alloc]initWithRootViewController:cvCtr];
        [self.navigationController presentViewController:navCtr animated:YES completion:nil];
}

- (IBAction)myLohasBtnPressed:(id)sender {
    RKMyLohasViewController *mvCtr =[[RKMyLohasViewController alloc]init];
    mvCtr.viewType =myLohasType;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:mvCtr];
}

- (IBAction)joinBtnPressed:(id)sender {
    RKJoinViewController *jvCtr =[[RKJoinViewController alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:jvCtr];
    
//    RKMyLohasViewController *mvCtr =[[RKMyLohasViewController alloc]init];
//    mvCtr.viewType =joinType;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:mvCtr];
}



@end
