//
//  RKDiscountViewController.m
//  Lohas
//
//  Created by Evan on 13-8-19.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKDiscountViewController.h"

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
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setView_ip5:nil];
    [self setView_ip4:nil];
    [self setTableView_ip5:nil];
    [self setTableView_ip4:nil];
    [super viewDidUnload];
}
- (IBAction)backBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"POPTOROOTCONTROLLER" object:nil];
}

#pragma mark - UI Setting
- (void)setupUI {
    if (IS_IPHONE_5) {
        [self.view addSubview:self.view_ip5];
    } else {
        [self.view addSubview:self.view_ip4];
    }
}

#pragma mark - tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    RKDiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell ==nil) {
        
        NSArray *xib=[[NSBundle mainBundle] loadNibNamed:@"RKDiscountCell" owner:self options:nil];
        
        cell =(RKDiscountCell *)[xib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.highlighted =NO;
    
    return cell;
}

@end
