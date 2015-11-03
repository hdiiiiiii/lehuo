//
//  RecommendTableViewCell.m
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "RecommendTableViewCell.h"


@implementation RecommendTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _creareCellView];
    }
    return self;
}

- (void)_creareCellView {
    
    _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.75)];
    _cellImageView.layer.cornerRadius = 5;
    _cellImageView.layer.masksToBounds = YES;
    _cellImageView.layer.borderWidth = 2;
    _cellImageView.layer.borderColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1].CGColor;
    
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _cellImageView.bounds.size.height-30, kScreenWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.7;
    
    [_cellImageView addSubview:view];
    
    _label = [[UILabel alloc] initWithFrame:view.bounds];
   
    _label.font = [UIFont systemFontOfSize:15 weight:0.3];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor darkGrayColor];
    [view addSubview:_label];
    
    [self addSubview:_cellImageView];
    
    
}
- (void)setModel:(RecommendModel *)model {
    
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
    
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    NSURL *url = [NSURL URLWithString:_model.app_cover];
    [_cellImageView sd_setImageWithURL:url];
    
     _label.text = _model.title;
    
    
    
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
