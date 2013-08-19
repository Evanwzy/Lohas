//
//  RKJoinViewController.m
//  Lohas
//
//  Created by Evan on 13-8-16.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKJoinViewController.h"

@interface RKJoinViewController ()

@end

@implementation RKJoinViewController

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
    
    //open SQLite
    m_sqlite =[[CSqlite alloc]init];
    [m_sqlite openSqlite];
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
    [self setViewSV:nil];
    [self setDoorPhotoBtn:nil];
    [self setCertificateBtn:nil];
    [self setLocationText:nil];
    [super viewDidUnload];
}


#pragma mark - UI Setting
- (void)setupUI {
    [self.viewSV setContentSize:CGSizeMake(320.0f, 635.0f)];
    
    if (IS_IPHONE_5) {
        [self.viewSV setFrame:CGRectMake(0.0f, 88.0f, 320.0f, 460.0f)];
    }else {
        [self.viewSV setFrame:CGRectMake(0.0f, 88.0f, 320.0f, 372.0f)];
    }
    
    [self.view addSubview:_viewSV];
}

#pragma mark - button Action

- (IBAction)backBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPCONTROLLER" object:nil];
}

- (IBAction)takeImageBtnPressed:(id)sender {
    UIButton *button =sender;
    
    if (button.tag ==DoorPhotoType) {
        _btnType =DoorPhotoType;
    }else {
        _btnType =CertificateType;
    }
    
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"从相册选取", nil ];
    [as showInView:self.view];
}

- (IBAction)GpsBtnPressed:(id)sender {
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

#pragma mark - UIKeyboardViewController delegate methods



- (void)alttextFieldDidEndEditing:(UITextField *)textField {
    
    
}

-(void)alttextFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark - ActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //照一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{
            }];
            
            
            
        }
            break;
        case 1:
            //搞一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{
            }];
            
            
            
            break;
        }
        default:
            break;
    }
    
    
}


#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (_btnType ==DoorPhotoType) {
        self.doorImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self.doorPhotoBtn setImage:_doorImage forState:UIControlStateNormal];
    } else {
        self.certificateImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self.certificateBtn setImage:_certificateImage forState:UIControlStateNormal];
    }
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
        CATransition *trans=[CATransition animation];
        [trans setDuration:0.25f];
        [trans setType:@"flip"];
        [trans setSubtype:kCATransitionFromLeft];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


#pragma mark - GPS Location Delegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    ;///火星GPS
    CLLocationCoordinate2D thisLocation =newLocation.coordinate;
    NSLog(@"纬度：%f, 经度：%f",
          thisLocation.latitude,
          thisLocation.longitude
          );
    thisLocation = [self zzTransGPS:thisLocation];
    
    
    NSLog(@"纬度：%f, 经度：%f",
          thisLocation.latitude,
          thisLocation.longitude
          );
    
    
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:thisLocation];
    geocoder.delegate = self;
    [geocoder start];

//    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation
//                   completionHandler:^(NSArray *placemarks,
//                                       NSError *error)
//     {
//         CLPlacemark *placemark=[placemarks objectAtIndex:0];
//         NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
//               placemark.name,
//               placemark.country,
//               placemark.postalCode,
//               placemark.ISOcountryCode,
//               placemark.ocean,
//               placemark.inlandWater,
//               placemark.administrativeArea,
//               placemark.subAdministrativeArea,
//               placemark.locality,
//               placemark.subLocality,
//               placemark.thoroughfare,
//               placemark.subThoroughfare);
//     }];
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [Common showNetWorokingAlertWithMessage:@"定位失败！"];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder
       didFindPlacemark:(MKPlacemark *)placemark
{
    NSLog(@"\n name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n locality:%@\n subLocality:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
          placemark.name,
          placemark.country,
          placemark.postalCode,
          placemark.ISOcountryCode,
          placemark.administrativeArea,
          placemark.subAdministrativeArea,
          placemark.locality,
          placemark.subLocality,
          placemark.thoroughfare,
          placemark.subThoroughfare);
    self.locationText.text =[NSString stringWithFormat:@"%@%@%@", placemark.administrativeArea, placemark.subLocality, placemark.thoroughfare];
}

-  (void)reverseGeocoder:(MKReverseGeocoder *)geocoder
        didFailWithError:(NSError *)error
{
    NSLog(@"reverse geocoder fail!!");
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

@end