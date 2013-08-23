//
//  RKCertifitionViewController.h
//  Lohas
//
//  Created by Evan on 13-8-20.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

//btnType
typedef enum {
    distanceBtn =100,
    kindBtn,
    choiceBtn
}BTNTYPE;

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CSqlite.h"

#import "Common.h"
#import "UIImageView+WebCache.h"

#import "RKNetWorkingManager.h"
#import "RKCertificationCell.h"
#import "NIDropDown.h"

@interface RKCertifitionViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, RKNetWorkingManagerCertifitionDataDelegate, NIDropDownDelegate> {
    //GPS location
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
    
    NIDropDown *dropDown;
    NIDropDown *dropDown2;
    NIDropDown *dropDown3;
}

@property int BtnType;

@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) UIRefreshControl *refreshControl;


@property (weak, nonatomic) IBOutlet UIImageView *topBGImgView;
@property (weak, nonatomic) IBOutlet UIImageView *btnBGImgView;


@property (weak, nonatomic) IBOutlet UIButton *kindBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)distanceBtnPressed:(id)sender;
- (IBAction)kindBtnPressed:(id)sender;
- (IBAction)choiceBtNPressed:(id)sender;

@end
