//
//  RKDetailViewController.h
//  Lohas
//
//  Created by Evan on 13-8-21.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Common.h"
#import "RKNetWorkingManager.h"

@interface RKDetailViewController : UIViewController <RKNetWorkingManagerDetailDelegate
>

@property (retain, nonatomic) NSString *shopID;
@property (retain, nonatomic) NSString *litatude;
@property (retain, nonatomic) NSString *longitude;

@property (strong, nonatomic) IBOutlet UIScrollView *viewSV;
@property (weak, nonatomic) IBOutlet UITextView *infoText;
@property (weak, nonatomic) IBOutlet UILabel *estateLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *cellPhoneLbl;


- (IBAction)mapBtnPressed:(id)sender;;
- (IBAction)backBtn:(id)sender;
@end
