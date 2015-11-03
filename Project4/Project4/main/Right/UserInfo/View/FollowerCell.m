//
//  FollowerCell.m
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "FollowerCell.h"
#import "UIImageView+WebCache.h"
#import "FollowerModel.h"

//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation FollowerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _createViews];
    }
    return self;
}

-(void)_createViews
{
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    _iconImageView.layer.cornerRadius = 15;
    _iconImageView.layer.masksToBounds = YES;
    [self addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 150, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_nameLabel];
    
    _noteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 25, 150, 20)];
    _noteCountLabel.font = [UIFont systemFontOfSize:12];
    _noteCountLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [self addSubview:_noteCountLabel];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(kScreenWidth-70, 10, 60, 30);
    [self addSubview:_followBtn];
    
    _followBtnLabel = [[UILabel alloc] initWithFrame:_followBtn.bounds];
    _followBtnLabel.textColor = [UIColor grayColor];
    _followBtnLabel.font = [UIFont systemFontOfSize:13];
    [_followBtn addSubview:_followBtnLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _bottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:_bottomView];
    
}

-(void)setModel:(FollowerModel *)model
{
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    
    _nameLabel.text = _model.username;
    _noteCountLabel.text = [NSString stringWithFormat:@"%@条笔记",_model.note_total];
    if ([_model.follow_status isEqualToNumber:@1]) {
        _followBtnLabel.text = @"已关注";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
