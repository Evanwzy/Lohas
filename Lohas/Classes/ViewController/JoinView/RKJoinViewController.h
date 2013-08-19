//
//  RKJoinViewController.h
//  Lohas
//
//  Created by Evan on 13-8-16.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

typedef enum {
    DoorPhotoType =0,
    CertificateType,
    KindType,
    SiteType
}BtnType;

typedef enum {
    MainShop =0,
    SubShop,
}ShopKind;

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "CSqlite.h"
#import "Common.h"
#import "RKNetWorkingManager.h"
#import "UIKeyboardViewController.h"
#import "NIDropDown.h"
#import "FlatDatePicker.h"
#import "RadioButton.h"

@interface RKJoinViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIKeyboardViewControllerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, NIDropDownDelegate, FlatDatePickerDelegate, RadioButtonDelegate> {
    UIKeyboardViewController *keyBoardController;
    
    //GPS location
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    
    //NIDropDown Button;
    NIDropDown *dropDwon;
}

@property int btnType;
@property (nonatomic ,retain) NSDictionary *userDict;

@property (weak, nonatomic) IBOutlet UITextField *kindText;
@property (weak, nonatomic) IBOutlet UITextField *siteText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UIButton       *doorPhotoBtn;
@property (weak, nonatomic) IBOutlet UITextField *dateText;

@property (weak, nonatomic) IBOutlet UIButton       *certificateBtn;
@property (weak, nonatomic) IBOutlet UITextField *peopleText;

@property (nonatomic, retain) UIImage   *doorImage;
@property (nonatomic, retain) UIImage   *certificateImage;
@property (nonatomic, retain) NSString  *city;
@property (nonatomic, retain) NSString  *site;
@property (nonatomic, retain) NSString  *peopleInCharge;
@property (nonatomic, retain) NSString  *latitude;
@property (nonatomic, retain) NSString  *longitude;
@property (nonatomic, retain) NSString  *shopKind;

@property (nonatomic, strong) FlatDatePicker *flatDatePicker;

@property (strong, nonatomic) IBOutlet UIScrollView *viewSV;

- (IBAction)kindBtnPressed:(id)sender;
- (IBAction)dateBtnPressed:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)takeImageBtnPressed:(id)sender;
- (IBAction)GpsBtnPressed:(id)sender;
@end
