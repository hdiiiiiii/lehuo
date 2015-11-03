//
//  SolarTermCell.h
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SolarTermModel;
@interface SolarTermCell : UITableViewCell
@property(nonatomic,strong)SolarTermModel *model;
@property(nonatomic,strong)UIImageView *bigImageView;
@end
