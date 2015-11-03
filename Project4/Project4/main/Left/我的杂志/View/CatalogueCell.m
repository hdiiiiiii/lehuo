//
//  CatalogueCell.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CatalogueCell.h"

@implementation CatalogueCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self _createCell];
    }
    return self;
}

- (void)_createCell {
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 44, 44)];
    _labelText = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 234, 44)];
    _labelText.font = [UIFont systemFontOfSize:16 weight:.3];
    _labelText.textAlignment = NSTextAlignmentLeft;
    
   // _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    //_labelText.backgroundColor = [UIColor blackColor];
    [self addSubview:_headImageView];
    [self addSubview:_labelText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
