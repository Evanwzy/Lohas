//
//  RKDiscountViewController.m
//  Lohas
//
//  Created by Evan on 13-8-19.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKDiscountViewController.h"

#import "RKDetailViewController.h"

@interface RKDiscountViewController ()

@end

@implementation RKDiscountViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefrash) name:@"ENDREFRASH" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [self setupUI];
    [self discountRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ENDREFRASH" object:nil];
    
    [self setView_ip5:nil];
    [self setView_ip4:nil];
    [self setTableView_ip5:nil];
    [self setTableView_ip4:nil];
    [super viewDidUnload];
}
- (IBAction)backBtnPressed:(id)sender {
    [Common cancelAllRequestOfAllQueue];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POPTOROOTCONTROLLER" object:nil];
}

#pragma mark - UI Setting
- (void)setupUI {
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl =refresh;
    if (IS_IPHONE_5) {
        [self.view addSubview:self.view_ip5];
        [self.tableView_ip5 addSubview:self.refreshControl];
    } else {
        [self.view addSubview:self.view_ip4];
        [self.tableView_ip4 addSubview:self.refreshControl];
    }
}

-(void)handleData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd日  h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次更新 %@", [formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [self discountRequest];
}

- (void)endRefrash {
    [self.refreshControl endRefreshing];
}

-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中..."];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Common cancelAllRequestOfAllQueue];
    NSDictionary *cellDict =[self.dataArr objectAtIndex:indexPath.row];
    
    RKDetailViewController *dvCtr =[[RKDetailViewController alloc]init];
    dvCtr.shopID =
    [cellDict objectForKey:@"store_id"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHCONTROLLER" object:dvCtr];
}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDict =[self.dataArr objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    
    
    RKDiscountCell *cell = (RKDiscountCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RKDiscountCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.infoImage setImageWithURL:[NSURL URLWithString:[cellDict objectForKey:@"file_address"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.highlighted =NO;
    
    return cell;
    
}


#pragma mark - NetWorkingManager
- (void) discountRequest {
    [Common cancelAllRequestOfAllQueue];
    RKNetWorkingManager *manager =[RKNetWorkingManager sharedManager];
    manager.discountDelegate =self;
    [manager getDiscountData:self.city];
}

-(void)discountData:(NSArray *)dataArray {
    self.dataArr =dataArray;
    if (IS_IPHONE_5) {
        [self.tableView_ip5 reloadData];
        [self.refreshControl endRefreshing];
    }else {
        [self.tableView_ip4 reloadData];
        [self.refreshControl endRefreshing];
    }
}


@end
