//
//  SolarTermCell.m
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "SolarTermCell.h"
#import "SolarTermModel.h"
@implementation SolarTermCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _createView];
    }
    return self;
}

-(void)_createView
{
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.75)];
    _bigImageView.layer.cornerRadius = 5;
    _bigImageView.layer.borderWidth = 2;
    _bigImageView.layer.borderColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1].CGColor;
    _bigImageView.layer.masksToBounds = YES;
    [self addSubview:_bigImageView];
}

-(void)setModel:(SolarTermModel *)model
{
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:_model.app_cover] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"完成");
    }];
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
