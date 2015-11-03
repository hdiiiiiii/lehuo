//
//  MyhomeViewController.h
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyhomeViewController : UIViewController
@property (nonatomic,assign)BOOL isUnnormal;
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,copy)NSString *bodyStr;
@property (nonatomic,copy)NSString *articleID;
@property (nonatomic,copy)NSString *type;
@end
