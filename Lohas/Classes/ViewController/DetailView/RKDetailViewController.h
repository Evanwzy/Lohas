//
//  RKDetailViewController.h
//  Lohas
//
//  Created by Evan on 13-8-21.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKJoinViewController.h"

#import "Common.h"
#import "RKNetWorkingManager.h"
#import "UIImageView+WebCache.h"

@interface RKDetailViewController : UIViewController <RKNetWorkingManagerDetailDelegate
>

@property (retain, nonatomic) NSString *shopID;
@property (retain, nonatomic) NSString *latitude;
@property (retain, nonatomic) NSString *longitude;

@property (strong, nonatomic) IBOutlet UIScrollView *viewSV;
@property (weak, nonatomic) IBOutlet UITextView *infoText;
@property (weak, nonatomic) IBOutlet UILabel *estateLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *cellPhoneLbl;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;
@property (strong, nonatomic) IBOutlet MKMapView *m_map;
@property (retain, nonatomic) POI *m_poi;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;


- (IBAction)mapBtnPressed:(id)sender;;
- (IBAction)backBtn:(id)sender;
- (IBAction)mapOkBtnPressed:(id)sender;
@end
