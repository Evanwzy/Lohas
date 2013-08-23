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

@interface POI : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *subtitle;
    NSString *title;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString *subtitle;
@property (nonatomic,retain) NSString *title;

-(id) initWithCoords:(CLLocationCoordinate2D) coords;

@end

@interface RKJoinViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIKeyboardViewControllerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate, NIDropDownDelegate, FlatDatePickerDelegate, RadioButtonDelegate, RKNetWorkingManagerJoinLohasDelegate> {
    UIKeyboardViewController *keyBoardController;
    
    //GPS location
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    
    //NIDropDown Button;
    NIDropDown *dropDwon;
}

@property int btnType;
@property (nonatomic, retain) NSDictionary *userDict;
@property (nonatomic, retain) POI *m_poi;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *ownerText;
@property (weak, nonatomic) IBOutlet UITextField *verifyText;
@property (weak, nonatomic) IBOutlet UITextField *kindText;
@property (weak, nonatomic) IBOutlet UITextField *siteText;
@property (weak, nonatomic) IBOutlet UITextField *locationText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;

@property (weak, nonatomic) IBOutlet UIButton       *doorPhotoBtn;
@property (weak, nonatomic) IBOutlet UITextField *dateText;

@property (weak, nonatomic) IBOutlet UIButton       *certificateBtn;
@property (weak, nonatomic) IBOutlet UITextField *peopleText;
@property (strong, nonatomic) IBOutlet MKMapView *m_map;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *gpsBtn;

@property int kindIndex;
@property (nonatomic, retain) UIImage   *doorImage;
@property (nonatomic, retain) UIImage   *certificateImage;
@property (nonatomic, retain) NSString  *city;
@property (nonatomic, retain) NSString  *site;
@property (nonatomic, retain) NSString  *peopleInCharge;
@property (nonatomic, retain) NSString  *latitude;
@property (nonatomic, retain) NSString  *longitude;
@property (nonatomic, retain) NSString  *shopKind;

@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@property (nonatomic, strong) UILabel *titleLbl;

@property (strong, nonatomic) IBOutlet UIScrollView *viewSV;

- (IBAction)checkBtnPressed:(id)sender;
- (IBAction)commitBtnPressed:(id)sender;
- (IBAction)kindBtnPressed:(id)sender;
- (IBAction)dateBtnPressed:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)takeImageBtnPressed:(id)sender;
- (IBAction)GpsBtnPressed:(id)sender;
- (IBAction)mapOKBtnPressed:(id)sender;

@end
