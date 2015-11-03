//
//  UserTopView.h
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserTopModel;
@interface UserTopView : UIView

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,strong)UserTopModel *model;
@end