//
//  RecommendTableViewCell.h
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"
@interface RecommendTableViewCell : UITableViewCell

@property (nonatomic,strong) RecommendModel *model;
@property (nonatomic,strong) UIImageView *cellImageView;
@property (nonatomic,strong) UILabel *label;



@end
