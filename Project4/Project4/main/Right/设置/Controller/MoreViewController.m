//
//  MoreViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableView.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    [self _createTableView];
    [self _createNavItem];
}
- (void)_createTableView {
    MoreTableView *moreTableView = [[MoreTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:moreTableView];
    
}

- (void)_createNavItem {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 30);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ico_return@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
    
    
    
    
    
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
