//
//  FollowerCell.h
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FollowerModel;
@interface FollowerCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *noteCountLabel;
@property (nonatomic,strong)UIButton *followBtn;
@property (nonatomic,strong)UILabel *followBtnLabel;
@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)FollowerModel *model;
@end
