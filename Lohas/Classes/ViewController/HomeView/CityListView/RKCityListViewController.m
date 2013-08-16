//
//  RKCityListViewController.m
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKCityListViewController.h"

@interface RKCityListViewController ()

@end

@implementation RKCityListViewController

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
    self.navigationController.navigationBarHidden =YES;
    
    NSArray *aArr =[NSArray arrayWithObjects:@"安庆", @"安康", nil];
    NSArray *bArr =[NSArray arrayWithObjects:@"北京", @"包头", nil];
    NSArray *cArr =[NSArray arrayWithObjects:@"成都", @"常州", nil];
    NSArray *dArr =[NSArray arrayWithObjects:@"大连", @"丹东", nil];
    NSArray *sArr =[NSArray arrayWithObjects:@"上海", @"深圳", nil];
    
    _valueArr =[[NSArray alloc]initWithObjects:aArr, bArr, cArr, dArr, sArr, nil];
    _keyArr =[[NSArray alloc]initWithObjects:@"a", @"b", @"c", @"d", @"s", nil];
    
    _cityDict =[[NSDictionary alloc]initWithObjects:_valueArr forKeys:_keyArr];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTableView2:nil];
    [self setView_ip4:nil];
    [self setView_ip5:nil];
    [super viewDidUnload];
}
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)setupUI {
    if (IS_IPHONE_5) {
        [self.view addSubview:_view_ip5];
    } else {
        [self.view addSubview:_view_ip4];
    }
}

#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_cityDict allKeys] count];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _keyArr;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text =[[_valueArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_valueArr objectAtIndex:section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_keyArr objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cityName =[[_cityDict objectForKey:[_keyArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults]setValue:cityName forKey:@"city"];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
