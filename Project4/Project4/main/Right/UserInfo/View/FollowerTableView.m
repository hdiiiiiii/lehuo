//
//  FollowerTableView.m
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "FollowerTableView.h"
#import "FollowerCell.h"
#import "UserInfoViewController.h"
#import "FollowerModel.h"
#import "UIView+UIViewController.h"
//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FollowerTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@end
@implementation FollowerTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[FollowerCell class] forCellReuseIdentifier:@"FollowerCell"];
        
        self.backgroundColor = [UIColor colorWithRed:236/255.0 green:244/255.0 blue:1 alpha:1];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    FollowerModel *model = _modelArray[indexPath.row];
    
    cell.model = model;
    
    cell.bottomView.frame = CGRectMake(4, cell.frame.size.height-1, kScreenWidth-8, 1);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserInfoViewController *userVC = [[UserInfoViewController alloc] init];
    FollowerModel *model = _modelArray[indexPath.row];
    
    userVC.uid = model.uid;
    
    [self.viewController.navigationController pushViewController:userVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
