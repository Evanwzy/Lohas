//
//  RKDetailViewController.m
//  Lohas
//
//  Created by Evan on 13-8-21.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKDetailViewController.h"

@interface RKDetailViewController ()

@end

@implementation RKDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setViewSV:nil];
    [self setPriceLbl:nil];
    [self setImgView:nil];
    [self setNameLbl:nil];
    [self setEstateLbl:nil];
    [self setAddressLbl:nil];
    [self setCellPhoneLbl:nil];
    [self setInfoText:nil];
    [super viewDidUnload];
}

#pragma mark - UI Setting
- (void)setupUI {
    
}

#pragma mark - NetWorking Request
- (void)detailRequest {
    [Common cancelAllRequestOfAllQueue];
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    manager.detailDelegate =self;
    [manager getdetailData:self.shopID];
}

-(void)detailData:(NSDictionary *)dataDict {
        self.nameLbl.text =[dataDict objectForKey:@"store_name"];
        self.priceLbl.text =[NSString stringWithFormat:@"人均：￥%@", [dataDict objectForKey:@"draw"]];
        self.estateLbl.text =[dataDict objectForKey:@"address"];
        self.cellPhoneLbl.text =[dataDict objectForKey:@"sotre_phone"];
        self.infoText.text =[dataDict objectForKey:@"introduce"];
}

#pragma mark - ButtonAction
- (IBAction)mapBtnPressed:(id)sender {
    
}

- (IBAction)backBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPCONTROLLER" object:nil];
}
@end
