//
//  CollectViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectionContentController.h"
@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏夹";
    
    [self _setNavItem];
    
    [self _createTableView];
}

-(void)_setNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 38, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"ico_return@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_createTableView
{
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    listView.dataSource = self;
    listView.delegate = self;
    
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    listView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    [self.view addSubview:listView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
        cell.backgroundColor = [UIColor clearColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(4, cell.frame.size.height-1, kScreenWidth-8, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [cell addSubview:lineView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"每日推荐";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"节气令";
    }
    else{
        cell.textLabel.text = @"杂志";
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionContentController *contentVC = [[CollectionContentController alloc] init];
    if (indexPath.row == 0) {
        contentVC.type = @"daily";
        contentVC.title = @"每日推荐";
    }
    else if (indexPath.row == 1){
        contentVC.type = @"season";
        contentVC.title = @"节气令";
    }
    else{
        contentVC.type = @"magazine";
        contentVC.title = @"杂志";
    }
    
    [self.navigationController pushViewController:contentVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
