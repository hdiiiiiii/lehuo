//
//  HomeTableViewCell.h
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModel;
@interface HomeTableViewCell : UITableViewCell

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
@property (nonatomic,assign)BOOL isUnnormal;
@property (nonatomic,strong) HomeModel *model;
@end
