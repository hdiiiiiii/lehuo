//
//  MagazineCell.h
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineModel.h"

@interface MagazineCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *coverImageView;
@property (nonatomic,strong)UIButton *downloadBtn;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIView *maskView;

@property (nonatomic,strong)MagazineModel *model;
@end
