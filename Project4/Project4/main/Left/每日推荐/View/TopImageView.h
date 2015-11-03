//
//  TopImageView.h
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopViewModel.h"

@interface TopImageView : UIScrollView

@property (nonatomic,strong) TopViewModel *model;
//@property (nonatomic,strong) NSArray *imageArray;
//@property (nonatomic,strong) UIImageView *imageView;
-(void)_loadURL;
@end
