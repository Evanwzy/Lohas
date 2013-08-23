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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonChange) name:@"COMMITENABLE" object:nil];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"COMMITENABLE" object:nil];
    
    [self setViewSV:nil];
    [self setDoorPhotoBtn:nil];
    [self setCertificateBtn:nil];
    [self setLocationText:nil];
    [self setPeopleText:nil];
    [self setDateText:nil];
    [self setKindText:nil];
    [self setSiteText:nil];
    [self setNameText:nil];
    [self setM_map:nil];
    [self setBackBtn:nil];
    [self setOkBtn:nil];
    [self setCommitBtn:nil];
    [self setAddressText:nil];
    [self setOwnerText:nil];
    [self setCheckBtn:nil];
    [self setVerifyText:nil];
    [self setBackImg:nil];
    [self setGpsBtn:nil];
    [super viewDidUnload];
}


#pragma mark - UI Setting
- (void)setupUI {
    [self.okBtn setHidden:YES];
    
    self.titleLbl =[[UILabel alloc]initWithFrame:CGRectMake(0.0f, 52.0f, 320.0f, 44.0f)];
    self.titleLbl.text =@"申请加盟乐活代理商";
    self.titleLbl.textAlignment =UITextAlignmentCenter;
    self.titleLbl.font =[UIFont systemFontOfSize:17.0f];
    self.titleLbl.textColor =[UIColor lightGrayColor];
    self.titleLbl.backgroundColor =[UIColor whiteColor];
    
    [self.viewSV setContentSize:CGSizeMake(320.0f, 1072.0f)];
    
    if (IS_IPHONE_5) {
        [self.viewSV setFrame:CGRectMake(0.0f, 96.0f, 320.0f, 452.0f)];
        [self.m_map setFrame:CGRectMake(0.0f, 52.0f, 320.0f, 496.0f)];
    }else {
        [self.viewSV setFrame:CGRectMake(0.0f, 96.0f, 320.0f, 366.0f)];
        [self.m_map setFrame:CGRectMake(0.0f, 52.0f, 320.0f, 408.0f)];
    }
    
    self.peopleInCharge =[self.userDict objectForKey:@"name"];
    self.peopleText.text =_peopleInCharge;
    
    RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"shop kind" index:0];
    RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"shop kind" index:1];
    
    rb1.frame = CGRectMake(140,783,22,22);
    rb2.frame = CGRectMake(230,783,22,22);
    
    [self.viewSV addSubview:rb1];
    [self.viewSV addSubview:rb2];
    
    [self.view addSubview:_m_map];
    [self.view addSubview:_titleLbl];
    [self.view addSubview:_viewSV];
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"请选择日期";
    self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    
    [RadioButton addObserverForGroupId:@"shop kind" observer:self];
}

#pragma mark - button Action

- (IBAction)checkBtnPressed:(id)sender {
    if ([self.ownerText.text isEqualToString:@""]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else {
        [self checkAccountRequest:self.ownerText.text];
        [self.checkBtn setTitle:@"请等待" forState:UIControlStateNormal];
        self.checkBtn.userInteractionEnabled =NO;
        [self performSelector:@selector(checkBtnUI) withObject:nil afterDelay:30.0f];
    }
}

- (void)checkBtnUI{
    if (IS_IPHONE_5) {
        [self.checkBtn setTitle:@"获取验证" forState:UIControlStateNormal];
        self.checkBtn.userInteractionEnabled =YES;
    } else {
        [self.checkBtn setTitle:@"请等待" forState:UIControlStateNormal];
        self.checkBtn.userInteractionEnabled =YES;
    }
}

- (IBAction)commitBtnPressed:(id)sender {
    [self.commitBtn setTitle:@"正在申请" forState:UIControlStateNormal];
    self.commitBtn.userInteractionEnabled =NO;
    [Common cancelAllRequestOfAllQueue];
    [self joinLohasRequest];
}

- (IBAction)kindBtnPressed:(id)sender {
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:[Common pathForPlist:@"trade"]];
    NSArray * arr = [[NSArray alloc] init];
    arr = [dict allValues];
    if(dropDwon == nil) {
        CGFloat f = 120;
        dropDwon = [[NIDropDown alloc]showDropDown:sender :&f :arr];
        dropDwon.delegate = self;
    }
    else {
        [dropDwon hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)dateBtnPressed:(id)sender {
    [self.flatDatePicker show];
}

- (IBAction)backBtn:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPTOROOTCONTROLLER" object:nil];
}

- (IBAction)takeImageBtnPressed:(id)sender {
    UIButton *button =sender;
    
    if (button.tag ==DoorPhotoType) {
        _btnType =DoorPhotoType;
    }else {
        _btnType =CertificateType;
    }
    
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"上传照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"从相册选取", nil ];
    [as showInView:self.view];
}

- (IBAction)GpsBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager =[[CLLocationManager alloc]init];
        locationManager.delegate =self;
        locationManager.distanceFilter =kCLDistanceFilterNone;
        locationManager.desiredAccuracy =kCLLocationAccuracyBestForNavigation;
        [locationManager startUpdatingLocation];
        NSLog(@"GPS开始");
        self.gpsBtn.userInteractionEnabled =NO;
    }else {
        [Common showNetWorokingAlertWithMessage:@"GPS不可用，请检查GPS状态。"];
    }
}

- (IBAction)mapOKBtnPressed:(id)sender {
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:7 withSubviewAtIndex:9];
    [UIView commitAnimations];
    [self.backBtn setHidden:NO];
    [self.backImg setHidden:NO];
    [self.okBtn setHidden:YES];
    self.gpsBtn.userInteractionEnabled =YES;
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


#pragma mark - Selected Photo
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (_btnType ==DoorPhotoType) {
        self.doorImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self.doorPhotoBtn setImage:_doorImage forState:UIControlStateNormal];
        
        NSData *doorImgData =UIImageJPEGRepresentation(self.doorImage, 0.5);
        [doorImgData writeToFile:[Common pathForImage:@"1.jpg"] atomically:YES];
        
    } else {
        self.certificateImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self.certificateBtn setImage:_certificateImage forState:UIControlStateNormal];
        
        NSData *certificateImgData =UIImageJPEGRepresentation(self.certificateImage, 0.5);
        [certificateImgData writeToFile:[Common pathForImage:@"2.jpg"] atomically:YES];
        
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
    
    //显示当前位置
    [self SetMapPoint:thisLocation];
    
    self.latitude =[NSString stringWithFormat:@"%f", thisLocation.latitude];
    self.longitude =[NSString stringWithFormat:@"%f", thisLocation.longitude];
    
    
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
    self.gpsBtn.userInteractionEnabled =YES;
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
    
    //view切换
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:7 withSubviewAtIndex:9];
    [UIView commitAnimations];
    [self.backBtn setHidden:!self.backBtn.hidden];
    [self.backImg setHidden:!self.backImg.hidden];
    [self.okBtn setHidden:NO];
    self.locationText.text =[NSString stringWithFormat:@"%@%@", placemark.administrativeArea, placemark.subLocality];
    self.city =placemark.administrativeArea ;
}

-  (void)reverseGeocoder:(MKReverseGeocoder *)geocoder
        didFailWithError:(NSError *)error
{
    self.gpsBtn.userInteractionEnabled =YES;
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

-(void)SetMapPoint:(CLLocationCoordinate2D)myLocation
{
    //添加大头针
    POI* m_poi = [[POI alloc]initWithCoords:myLocation];
    m_poi.title = @"当前位置";
    
    [self.m_map addAnnotation:m_poi];
    
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center=myLocation;
    [self.m_map setZoomEnabled:YES];
    [self.m_map setScrollEnabled:YES];
    theRegion.span.longitudeDelta = 0.01f;
    theRegion.span.latitudeDelta = 0.01f;
    [self.m_map setRegion:theRegion animated:YES];
}

#pragma mark - NIDrop Button Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender :(NSString *)text :(int)indexPath{
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:[Common pathForPlist:@"trade"]];
    
    self.kindText.text =text;
    self.kindIndex =[[[dict allKeysForObject:text] objectAtIndex:0] intValue];
    [self rel];
}

-(void)rel{
    dropDwon = nil;
}

#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    
//    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
//        [dateFormatter setDateFormat:@"yyyy年MMMMdd日"];
//    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//    } else {
//        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
//    }
//    
//    NSString *value = [dateFormatter stringFromDate:date];
//    
//    self.dateText.text = value;
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:@"Did cancelled !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alertView show];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy年MMMMdd日"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.dateText.text = value;
    
//    NSString *message = [NSString stringWithFormat:@"Did valid date : %@", value];
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FlatDatePicker" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alertView show];
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    self.shopKind =[NSString stringWithFormat:@"%d", index+1];
}

#pragma mark - Upload User Info

- (void) joinLohasRequest {
    if (self.nameText.text.length !=0 && self.ownerText.text.length !=0 &&self.verifyText.text.length !=0 &&self.locationText.text.length !=0 &&self.addressText.text.length !=0 &&self.dateText.text.length !=0 &&self.peopleText.text.length !=0 &&self.doorImage !=nil &&self.certificateImage !=nil &&self.shopKind !=0) {
        [Common cancelAllRequestOfAllQueue];
        RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
        manager.joinLohasDelegate =self;
        
        [manager joinLohasWithName:self.nameText.text Account:[self.userDict objectForKey:@"account"] ownerAccount:self.ownerText.text Verify:self.verifyText.text Kind:[NSString stringWithFormat:@"%d", self.kindIndex] Site:self.siteText.text Latitude:self.latitude Longitude:self.longitude Address:[self.locationText.text stringByAppendingString:self.addressText.text] Doorphoto:self.doorImage Date:self.dateText.text ShopKind:self.shopKind Certificatephoto:self.certificateImage PeopleInCharge:self.peopleText.text Ctiy:self.city];
    }else {
        self.commitBtn.userInteractionEnabled =YES;
        [self.commitBtn setTitle:@"申请" forState:UIControlStateNormal];
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"信息不完整" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)getjoinLohasResult {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POPTOCONTROLLER" object:nil];
}

- (void)checkAccountRequest:(NSString *)accountStr {
    [Common cancelAllRequestOfAllQueue];
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    [manager checkStoreWithAccount:accountStr];
}

- (void) buttonChange {
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.commitBtn.userInteractionEnabled =YES;
}

@end

@implementation POI

@synthesize coordinate,subtitle,title;

- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    
    self = [super init];
    
    if (self != nil) {
        
        coordinate = coords;
        
    }
    
    return self;
    
}


@end
