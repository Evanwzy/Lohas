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
#import "RKCertifitionViewController.h"

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
    [Common cancelAllRequestOfAllQueue];
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager =[[CLLocationManager alloc]init];
        locationManager.delegate =self;
        locationManager.distanceFilter =kCLDistanceFilterNone;
        locationManager.desiredAccuracy =kCLLocationAccuracyBestForNavigation;
        [locationManager startUpdatingLocation];
        NSLog(@"GPS开始");
    }else {
        [Common showNetWorokingAlertWithMessage:@"GPS不可用，请检查GPS状态。"];
    }
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
        [self.cityBtn2 setTitle:city forState:UIControlStateNormal];
    }
    
//    [[RKNetWorkingManager sharedManager] netTest];
}

#pragma mark - GPS Location Delegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    ;///火星GPS
    CLLocationCoordinate2D thisLocation =newLocation.coordinate;
    thisLocation = [self zzTransGPS:thisLocation];
    
    NSArray *arrValue =[NSArray arrayWithObjects:[NSNumber numberWithFloat:thisLocation.latitude], [NSNumber numberWithFloat:thisLocation.longitude],nil];
    NSDictionary *dict =[NSDictionary dictionaryWithObjects:arrValue forKeys:@[@"latitude", @"longitude"]];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"location"];
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [Common showNetWorokingAlertWithMessage:@"定位失败！"];
}

-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
        
    }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
    
    
}

#pragma mark - button action

- (IBAction)cityBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
        RKCityListViewController *cvCtr =[[RKCityListViewController alloc]init];
        UINavigationController *navCtr =[[UINavigationController alloc]initWithRootViewController:cvCtr];
        [self.navigationController presentViewController:navCtr animated:YES completion:nil];
}

- (IBAction)discountBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    RKDiscountViewController *dvCtr =[[RKDiscountViewController alloc]init];
    if (IS_IPHONE_5) {
        dvCtr.city =self.cityBtn.titleLabel.text;
    } else {
        dvCtr.city =self.cityBtn2.titleLabel.text;
    }
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

- (IBAction)certificationBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    RKCertifitionViewController *cvCtr =[[RKCertifitionViewController alloc]init];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:cvCtr];
}



@end
