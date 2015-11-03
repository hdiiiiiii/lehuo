//
//  UserInfoCell.m
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _createViews];
    }
    
    return self;
}

-(void)_createViews
{
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 30, 30)];
    _iconImageView.image = [UIImage imageNamed:@"heart_red"];
    [self addSubview:_iconImageView];
    _iconImageView.layer.cornerRadius = 5;
    _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.masksToBounds = YES;
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _userNameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_userNameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    [self addSubview:_timeLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    [self addSubview:_contentLabel];
    
    _heartBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_heartBtn setBackgroundImage:[UIImage imageNamed:@"heart_gray"] forState:UIControlStateNormal];
    [_heartBtn setBackgroundImage:[UIImage imageNamed:@"heart_red"] forState:UIControlStateSelected];
    [self addSubview:_heartBtn];
    
    _heartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _heartLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    _heartLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_heartLabel];
    
    
    _deletBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_deletBtn setBackgroundImage:[UIImage imageNamed:@"ico_delete@2x"] forState:UIControlStateNormal];
    [self addSubview:_deletBtn];
    
    _followsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_followsBtn setBackgroundImage:[UIImage imageNamed:@"ico_leavemessage@2x"] forState:UIControlStateNormal];
    [self addSubview:_followsBtn];
    
    _followsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _followsLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    _followsLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_followsLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _bottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:_bottomView];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
