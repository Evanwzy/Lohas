//
//  RKJoinViewController.h
//  Lohas
//
//  Created by Evan on 13-8-16.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

typedef enum {
    DoorPhotoType =0,
    CertificateType
}BtnType;


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "CSqlite.h"
#import "Common.h"
#import "RKNetWorkingManager.h"
#import "UIKeyboardViewController.h"



@interface RKJoinViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIKeyboardViewControllerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
    UIKeyboardViewController *keyBoardController;
    
    //GPS location
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
}

@property int btnType;
@property (nonatomic, retain) UIImage   *doorImage;
@property (nonatomic, retain) UIImage   *certificateImage;
@property (nonatomic, retain) NSString  *city;
@property (nonatomic, retain) NSString  *site;

@property (strong, nonatomic) IBOutlet UIScrollView *viewSV;
@property (weak, nonatomic) IBOutlet UIButton       *doorPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton       *certificateBtn;
@property (weak, nonatomic) IBOutlet UITextField *locationText;

- (IBAction)backBtn:(id)sender;
- (IBAction)takeImageBtnPressed:(id)sender;
- (IBAction)GpsBtnPressed:(id)sender;
@end
