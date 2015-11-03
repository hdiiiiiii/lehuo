//
//  HomeTableViewCell.m
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "HomeModel.h"

@implementation HomeTableViewCell

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self _createViews];
//    }
//    return self;
//}
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
    _bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomView];
}




//-(void)setModel:(HomeModel *)model
//{
//    if (_model != model) {
//        _model = model;
//        
//        [self setNeedsLayout];
//    }
//}
//
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//}

//-(CGSize)labelsize:(NSString *)str
//{
//    CGSize size = CGSizeMake(kScreenWidth-50, 20000);
//    NSDictionary *atttibutes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
//    CGRect fram = [str boundingRectWithSize:size
//                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                 attributes:atttibutes
//                                    context:nil];
//    return fram.size;
//    
//}
//
//-(NSString *)getTime:(NSString *)timeSP
//{
//    NSInteger time = [timeSP integerValue];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//    //获取月份和日期
//    [dateformatter setDateFormat:@"YY"];
//    NSString *yearString=[dateformatter stringFromDate:date];
//    [dateformatter setDateFormat:@"MM"];
//    NSString *monthString=[dateformatter stringFromDate:date];
//    [dateformatter setDateFormat:@"dd"];
//    NSString *dayString=[dateformatter stringFromDate:date];
//    return [NSString stringWithFormat:@"20%@年%@月%@日",yearString,monthString,dayString];
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
