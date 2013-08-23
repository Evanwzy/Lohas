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
    self.infoText.text =@"";
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [self detailRequest];
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
    [self setInfoImageView:nil];
    [super viewDidUnload];
}

#pragma mark - UI Setting
- (void)setupUI {
    [self.nameLbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_titleBg@2x.png"]]];
    UIImage *bgImage =[[UIImage imageNamed:@"detail_infoBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    if (IS_IPHONE_5) {
        [self.viewSV setFrame:CGRectMake(0.0f, 77.0f, 320.0f, 471.0f)];
        self.infoImageView.image =bgImage;
    }else {
        [self.viewSV setFrame:CGRectMake(0.0f, 77.0f, 320.0f, 383.0f)];
        self.infoImageView.frame =CGRectMake(0.0f, 166, 320, 314);
        self.infoImageView.image =bgImage;
    }
    
    CGSize constraintSize;
    constraintSize.width = 280;
    constraintSize.height = MAXFLOAT;
    CGSize sizeFrame =[self.infoText.text sizeWithFont:self.infoText.font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    self.infoText.frame = CGRectMake(20,314,280.0,sizeFrame.height*3/2);
    [self.viewSV setContentSize:CGSizeMake(320.0f, 314.0f+sizeFrame.height*3/2)];
    
    [self.view addSubview:self.viewSV];
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
    self.estateLbl.text =[dataDict objectForKey:@"estate"];
    self.cellPhoneLbl.text =[dataDict objectForKey:@"store_phone"];
    self.infoText.text =[dataDict objectForKey:@"introduce"];
    self.addressLbl.text =[dataDict objectForKey:@"address"];
    [self.imgView setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:@"file_address"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    
    [self setupUI];
}

#pragma mark - ButtonAction
- (IBAction)mapBtnPressed:(id)sender {
    
}

- (IBAction)backBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPCONTROLLER" object:nil];
}
@end
