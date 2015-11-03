//
//  DetailViewController.h
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolarTermModel.h"
@interface DetailViewController : UIViewController
@property (nonatomic,strong) SolarTermModel *model;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,assign)BOOL isUnNormal;
@end
