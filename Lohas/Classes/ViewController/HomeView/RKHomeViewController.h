//
//  RKHomeViewController.h
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CSqlite.h"

#import "Common.h"

@interface RKHomeViewController : UIViewController <CLLocationManagerDelegate> {
    //GPS location
    CLLocationManager *locationManager;
    CSqlite *m_sqlite;
}

@property (strong, nonatomic) IBOutlet UIView *view_ip5;
@property (strong, nonatomic) IBOutlet UIView *view_ip4;

@property (retain, nonatomic) IBOutlet UIButton *cityBtn;
@property (retain, nonatomic) IBOutlet UIButton *cityBtn2;

- (IBAction)cityBtnPressed:(id)sender;

- (IBAction)discountBtnPressed:(id)sender;
- (IBAction)myLohasBtnPressed:(id)sender;
- (IBAction)joinBtnPressed:(id)sender;
- (IBAction)certificationBtnPressed:(id)sender;


@end
