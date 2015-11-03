//
//  MagazineDetailsCell.h
//  Project4
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineDetailsModel.h"

@interface MagazineDetailsCell : UICollectionViewCell <UIScrollViewDelegate>
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIScrollView *scrollerView;
@property (nonatomic,strong)MagazineDetailsModel *model;

-(void)backImageZoomingScale;


@end
