//
//  RKCertificationCell.h
//  Lohas
//
//  Created by Evan on 13-8-20.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKCertificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *storePic;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *estateLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;

@end
