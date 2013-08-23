//
//  RKCertifitionViewController.m
//  Lohas
//
//  Created by Evan on 13-8-20.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKCertifitionViewController.h"

#import "RKDetailViewController.h"

@interface RKCertifitionViewController ()

@end

@implementation RKCertifitionViewController

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
    self.dataArray =[[NSArray alloc]init];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl =refresh;
    [self.tableView addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefrash) name:@"ENDREFRASH" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager =[[CLLocationManager alloc]init];
        locationManager.delegate =self;
        locationManager.distanceFilter =kCLDistanceFilterNone;
        locationManager.desiredAccuracy =kCLLocationAccuracyBestForNavigation;
        [locationManager startUpdatingLocation];
        NSLog(@"GPS开始");
    }else {
        [Common showNetWorokingAlertWithMessage:@"GPS不可用，请检查GPS状态。"];
    }
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd日  h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次更新 %@", [formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [self certificationRequest];
    
}

- (void)endRefrash {
    [self.refreshControl endRefreshing];
}


-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中..."];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:1];
    }
}


#pragma mark - GPS Location Delegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    ;///火星GPS
    CLLocationCoordinate2D thisLocation =newLocation.coordinate;
    thisLocation = [self zzTransGPS:thisLocation];
    
    NSArray *arrValue =[NSArray arrayWithObjects:[NSNumber numberWithFloat:thisLocation.latitude], [NSNumber numberWithFloat:thisLocation.longitude],nil];
    NSDictionary *dict =[NSDictionary dictionaryWithObjects:arrValue forKeys:@[@"latitude", @"longitude"]];
    
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"location"];
    
    [self certificationRequest];
}

// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [Common showNetWorokingAlertWithMessage:@"定位失败！"];
}

-(CLLocationCoordinate2D)zzTransGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW)
    {
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
        
    }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
    
    
}

#pragma mark - UI Setting
- (void)setupUI {
    if (! IS_IPHONE_5) {
        [self.tableView setFrame:CGRectMake(0.0f, 93.0f, 320.0f, 367.0f)];
    }
    self.topBGImgView.image =[[UIImage imageNamed:@"topBack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
    UIImage *btnSelectedImage =[[UIImage imageNamed:@"btnSelected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 0, 3, 0)];
    [self.kindBtn setBackgroundImage:btnSelectedImage forState:UIControlStateSelected];
    [self.distanceBtn setBackgroundImage:btnSelectedImage forState:UIControlStateSelected];
    [self.choiceBtn setBackgroundImage:btnSelectedImage forState:UIControlStateSelected];
    
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ENDREFRASH" object:nil];
    
    [self setTableView:nil];
    [self setKindBtn:nil];
    [self setDistanceBtn:nil];
    [self setChoiceBtn:nil];
    [self setTopBGImgView:nil];
    [self setBtnBGImgView:nil];
    [super viewDidUnload];
}

#pragma mark - NIDrop Button Delegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender :(NSString *)text :(int)indexPath{
    if([sender isEqual:dropDown]) {
        [self.kindBtn setTitle:text forState:UIControlStateNormal];
        [self rel:sender];
    }else if([sender isEqual:dropDown2]) {
        [self.distanceBtn setTitle:text forState:UIControlStateNormal];
        [self rel:sender];
    }else if([sender isEqual:dropDown3]) {
        [self.choiceBtn setTitle:text forState:UIControlStateNormal];
        [self rel:sender];
    }
    [self certificationRequest];
}

-(void)rel :(NIDropDown *)sender{
    if([sender isEqual:dropDown]) {
        self.kindBtn.selected =NO;
        dropDown = nil;
    }else if([sender isEqual:dropDown2]) {
        self.distanceBtn.selected =NO;
        dropDown2 = nil;
    }else if([sender isEqual:dropDown3]) {
        self.choiceBtn.selected =NO;
        dropDown3 = nil;
    }
    
}

-(void)relBtn :(id)sender{
    if([sender isEqual:self.kindBtn]) {
        self.kindBtn.selected =NO;
        dropDown = nil;
    }else if([sender isEqual:self.distanceBtn]) {
        self.distanceBtn.selected =NO;
        dropDown2 = nil;
    }else if([sender isEqual:self.choiceBtn]) {
        self.choiceBtn.selected =NO;
        dropDown3 = nil;
    }
    
}


#pragma mark - NetWorkingRequest

- (void)certificationRequest {
    [Common cancelAllRequestOfAllQueue];
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    manager.certificationDataDelegate =self;
    
    NSDictionary *dict =[[NSUserDefaults standardUserDefaults]objectForKey:@"location"];
    
    NSString *latitude= [dict objectForKey:@"latitude"] ;
    NSString *longitude= [dict objectForKey:@"longitude"] ;
    NSString *distanceStr =self.distanceBtn.titleLabel.text;
    
    if (latitude !=nil &&longitude !=nil) {
        NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:[Common pathForPlist:@"trade"]];
        NSString *kindIndex =[[dict allKeysForObject:self.kindBtn.titleLabel.text] objectAtIndex:0];
        [manager getCertifitionDataWithLatitude:latitude Longitude:longitude distance:[distanceStr substringToIndex:distanceStr.length-2] kind:kindIndex];
    }
}

- (void)certificationData:(NSArray *)dataArray {
    self.dataArray =dataArray;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Common cancelAllRequestOfAllQueue];
    NSDictionary *cellDict =[self.dataArray objectAtIndex:indexPath.row];
    
    RKDetailViewController *dvCtr =[[RKDetailViewController alloc]init];
    dvCtr.shopID =
    [cellDict objectForKey:@"id"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:dvCtr];
    
}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDict =[self.dataArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";

    
    RKCertificationCell *cell = (RKCertificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RKCertificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.storePic setImageWithURL:[NSURL URLWithString:[cellDict objectForKey:@"store_pic"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    cell.storeName.text =[cellDict objectForKey:@"store_name"];
    cell.priceLbl.text =[NSString stringWithFormat:@"人均 ￥: %@", [cellDict objectForKey:@"draw"]];
    cell.estateLbl.text =[cellDict objectForKey:@"estate"];
    cell.distanceLbl.text =[cellDict objectForKey:@"distance"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.highlighted =NO;
    
    return cell;
    
}

#pragma mark - button Action
- (IBAction)backBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POPTOROOTCONTROLLER" object:nil];
}

- (IBAction)distanceBtnPressed:(id)sender {
    
    NSArray * arr = [[NSArray alloc] initWithObjects:@"1km", @"10km", @"50km", @"100km", nil];
    if(dropDown2 == nil) {
        self.distanceBtn.selected =YES;
        CGFloat f = 120;
        dropDown2 = [[NIDropDown alloc]showDropDown:sender :&f :arr];
        dropDown2.delegate = self;
    }
    else {
        [dropDown2 hideDropDown:sender];
        [self relBtn:sender];
    }
    
    if(dropDown != nil) {
        [dropDown hideDropDown:self.kindBtn];
        [self relBtn:self.kindBtn];
    }
    if(dropDown3 != nil) {
        [dropDown3 hideDropDown:self.choiceBtn];
        [self relBtn:self.choiceBtn];
    }
}

- (IBAction)kindBtnPressed:(id)sender {
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:[Common pathForPlist:@"trade"]];
    NSArray * arr = [[NSArray alloc] init];
    arr = [dict allValues];
    if(dropDown == nil) {
        self.kindBtn.selected =YES;
        CGFloat f = 120;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self relBtn:sender];
    }
    
    if(dropDown2 != nil) {
        [dropDown2 hideDropDown:self.distanceBtn];
        [self relBtn:self.distanceBtn];
    }
    if(dropDown3 != nil) {
        [dropDown3 hideDropDown:self.choiceBtn];
        [self relBtn:self.choiceBtn];
    }
}

- (IBAction)choiceBtNPressed:(id)sender {
    NSArray * arr = [[NSArray alloc] initWithObjects:@"在线商家", @"全部商家", nil];
    if(dropDown3 == nil) {
        self.choiceBtn.selected =YES;
        CGFloat f = 120;
        dropDown3 = [[NIDropDown alloc]showDropDown:sender :&f :arr];
        dropDown3.delegate = self;
    }
    else {
        [dropDown3 hideDropDown:sender];
        [self relBtn:sender];
    }
    
    if(dropDown != nil) {
        [dropDown hideDropDown:self.kindBtn];
        [self relBtn:self.kindBtn];
    }
    if(dropDown2 != nil) {
        [dropDown2 hideDropDown:self.distanceBtn];
        [self relBtn:self.distanceBtn];
    }
}

@end
