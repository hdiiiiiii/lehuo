//
//  MagazineCell.m
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineCell.h"

@implementation MagazineCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _createViews];
    }
    return self;
}

-(void)_createViews
{
    CGFloat itemSize = (kScreenWidth - 50)/3;
    _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemSize, itemSize*1.43)];
    _coverImageView.image = [UIImage imageNamed:@"btn_download@2x"];
    [self addSubview:_coverImageView];
    
    _downloadBtn  = [[UIButton alloc] initWithFrame:CGRectMake(itemSize-40, itemSize*1.43-40, 40, 40)];
    [_downloadBtn setBackgroundImage:[UIImage imageNamed:@"btn_download@2x"] forState:UIControlStateNormal];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, itemSize*1.43, itemSize, 20)];
    [self addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14 weight:1];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, itemSize*1.43+20, itemSize, 40)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    _timeLabel.numberOfLines = 0;
    [self addSubview:_timeLabel];
    
    _maskView = [[UIView alloc] initWithFrame:_coverImageView.bounds];
    _maskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:.2];
    [self addSubview:_maskView];
    [self addSubview:_downloadBtn];
}

-(void)setModel:(MagazineModel *)model
{
    if (_model != model) {
        _model = model;
        
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
        _titleLabel.text = model.title;
        _timeLabel.text = model.pub_date;
        
    }
}




@end
