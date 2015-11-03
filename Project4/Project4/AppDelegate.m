//
//  AppDelegate.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "BaseNavController.h"
@interface AppDelegate ()

@end



@implementation AppDelegate
@synthesize wbtoken;
@synthesize wbCurrentUserID;

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    MainTabBarController *mainTabBarView = [[MainTabBarController alloc] init];
    LeftViewController *leftView = [[LeftViewController  alloc] init];
    RightViewController *rightView = [[RightViewController alloc] init];
   // BaseNavController *baseNav = [[BaseNavController alloc] initWithRootViewController:rightView];
    
    MMDrawerController *mmDrawController = [[MMDrawerController alloc] initWithCenterViewController:mainTabBarView leftDrawerViewController:leftView rightDrawerViewController:rightView];
    
    //设置宽度
    [mmDrawController setMaximumLeftDrawerWidth:kScreenWidth*0.8];
    [mmDrawController setMaximumRightDrawerWidth:kScreenWidth*0.8];
    //设置手势区域
    [mmDrawController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    [mmDrawController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //设置动画
    MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState slideAndScaleVisualStateBlock];
    [mmDrawController setDrawerVisualStateBlock:block];
    
    
    
    self.window.rootViewController = mmDrawController;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLeftC) name:kLeftTabbarSelected object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeRight) name:kRightTabbarSelected object:nil];
    return YES;
}


//接收通知关闭左侧控制器
- (void)closeLeftC
{
    MMDrawerController *mmController = (MMDrawerController *)_window.rootViewController;
    [mmController closeDrawerAnimated:YES completion:nil];
}

- (void)closeRight
{
    MMDrawerController *mmController = (MMDrawerController *)_window.rootViewController;
    [mmController closeDrawerAnimated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
    }
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}
@end
