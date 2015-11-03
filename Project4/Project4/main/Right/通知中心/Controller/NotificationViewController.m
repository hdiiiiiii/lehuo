//
//  NotificationViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通知中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _setNavCItem];
    
    [self _createView];
}

-(void)_setNavCItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 40);
    
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_return@2x"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)_createView
{
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, kScreenHeight/2-70, 100, 20)];
    backLabel.text = @"您没有收到通知";
    backLabel.textColor = [UIColor grayColor];
    backLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:backLabel];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
