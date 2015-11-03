//
//  AppDelegate.h
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *wbRefreshToken;
@end

