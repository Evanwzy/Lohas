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
    [self.m_map setFrame:CGRectMake(0.0f, 77.0f, 320.0f, 471.0f)];
    [self.view addSubview:self.m_map];
    [self.view addSubview:self.viewSV];
    
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
    [self setMapBtn:nil];
    [self setM_map:nil];
    [self setBackBtn:nil];
    [self setBackImg:nil];
    [self setOkBtn:nil];
    [super viewDidUnload];
}

#pragma mark - UI Setting
- (void)setupUI {
    [self.okBtn setHidden:YES];
    
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
    
}

#pragma mark - NetWorking Request
- (void)detailRequest {
    [Common cancelAllRequestOfAllQueue];
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    manager.detailDelegate =self;
    [manager getdetailData:self.shopID];
}

-(void)detailData:(NSDictionary *)dataDict {
    self.latitude =[dataDict objectForKey:@"lat"];
    self.longitude =[dataDict objectForKey:@"lng"];
    self.nameLbl.text =[dataDict objectForKey:@"store_name"];
    self.priceLbl.text =[NSString stringWithFormat:@"人均：￥%@", [dataDict objectForKey:@"draw"]];
    self.estateLbl.text =[dataDict objectForKey:@"estate"];
    self.cellPhoneLbl.text =[dataDict objectForKey:@"store_phone"];
    self.infoText.text =[dataDict objectForKey:@"introduce"];
    self.addressLbl.text =[dataDict objectForKey:@"address"];
    [self.imgView setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:@"file_address"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    
    [self setupUI];
}

-(void)SetMapPoint:(CLLocationCoordinate2D)myLocation
{
    //添加大头针
    if (self.m_poi !=nil) {
        [self.m_map removeAnnotation:self.m_poi];
    }
    self.m_poi = [[POI alloc]initWithCoords:myLocation];
    self.m_poi.title = self.addressLbl.text;
    
//    self.m_map.showsUserLocation =YES;
    [self.m_map addAnnotation:_m_poi];
    
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center=myLocation;
    [self.m_map setZoomEnabled:YES];
    [self.m_map setScrollEnabled:YES];
    theRegion.span.longitudeDelta = 0.01f;
    theRegion.span.latitudeDelta = 0.01f;
    [self.m_map setRegion:theRegion animated:YES];
}

#pragma mark - ButtonAction
- (IBAction)mapBtnPressed:(id)sender {
    self.okBtn.hidden =NO;
    self.backBtn.hidden =YES;
    self.backImg.hidden =YES;
    
    CLLocationCoordinate2D location;
    location.latitude =[self.latitude floatValue];
    location.longitude =[self.longitude floatValue];
    [self SetMapPoint:location];
    
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:8 withSubviewAtIndex:7];
    [UIView commitAnimations];
    self.mapBtn.userInteractionEnabled=NO;
}

- (IBAction)backBtn:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POPCONTROLLER" object:nil];
}

- (IBAction)mapOkBtnPressed:(id)sender {
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:8 withSubviewAtIndex:7];
    [UIView commitAnimations];
    [self.backBtn setHidden:NO];
    [self.backImg setHidden:NO];
    [self.okBtn setHidden:YES];
    [self performSelector:@selector(delayM) withObject:nil afterDelay:0.9f];
}

- (void) delayM {
    self.mapBtn.userInteractionEnabled =YES;
}
@end
