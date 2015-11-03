//
//  BaseViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface BaseViewController ()
{
    
}

@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
  

    [self setNavItem];
    
    
    //设置导航栏LOGO
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 43)];
    imageView.image = [UIImage imageNamed:@"logo1@2x"];
    self.navigationItem.titleView = imageView;

}

//自定义导航栏按钮

- (void)setNavItem {

   //导航栏左侧按钮
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 35, 35);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ico_btnleftnav@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
    
    
    //导航栏右侧按钮
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton1.frame = CGRectMake(0, 0, 35, 35);
    [rightButton1 setBackgroundImage:[UIImage imageNamed:@"ico_btnrightnav@2x"] forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(rigthtOneAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton2.frame = CGRectMake(0, 0, 35, 35);
    [rightButton2 setBackgroundImage:[UIImage imageNamed:@"btn_magazine@2x"] forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(rigthtTowAction:) forControlEvents:UIControlEventTouchUpInside];
 
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton2];
    
    self.navigationItem.rightBarButtonItems = @[right1,right2];
    
    
}

#pragma mark - 按钮方法

- (void)leftAction {
    
    MMDrawerController *drawController = self.mm_drawerController;
    [drawController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    
}

- (void)rigthtOneAction {
    
    NSLog(@"right1");
    MMDrawerController *drawController = self.mm_drawerController;
    [drawController openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}

- (void)rigthtTowAction:(UIButton *)button {
    
    NSLog(@"right2");
 
    [[NSNotificationCenter defaultCenter] postNotificationName:kNavButtonSelected object:@"0"];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha = 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
