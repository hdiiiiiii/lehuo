//
//  MoreTableViewCell.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
       // self.layer.borderWidth = 1;
        //self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 3;
        
        [self _createSubviews];
        
    }
    return self;
    
}


- (void)_createSubviews {
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 34)];
    
    self.label.font = [UIFont systemFontOfSize:18 weight:.5];
    
  //  self.switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-60, 5, 34, 34)];
    
    [self addSubview:self.label];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
