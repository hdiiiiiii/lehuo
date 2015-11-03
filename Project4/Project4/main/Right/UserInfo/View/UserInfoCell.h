//
//  UserInfoCell.h
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;
@interface UserInfoCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *userNameLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIButton *heartBtn;
@property (nonatomic,strong)UILabel *heartLabel;
@property (nonatomic,strong)UIButton *deletBtn;
@property (nonatomic,strong)UIButton *followsBtn;
@property (nonatomic,strong)UILabel *followsLabel;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UserInfoModel *model;


@end
