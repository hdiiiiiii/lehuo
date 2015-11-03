//
//  CatalogueViewController.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CatalogueViewController.h"
#import "CatalogueTableView.h"

@interface CatalogueViewController ()
{
    
}

@end

@implementation CatalogueViewController

-(instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"目录";
        
        _tableView = [[CatalogueTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        
        [self.view addSubview:_tableView];
        
        [self _createNavItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    //[_tableView reloadData];
    //[self.tableView reloadData];
}


- (void)_createNavItem {
    
    UIButton *rightButt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButt.frame = CGRectMake(0, 0, 30, 30);
    [rightButt setImage:[UIImage imageNamed:@"btn_close@2x"] forState:UIControlStateNormal];
    [rightButt addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButt];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)backAction:(UIButton *)button {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
