//
//  SolarTermTableView.m
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "SolarTermTableView.h"
#import "SolarTermCell.h"
#import "UIView+UIViewController.h"
#import "MJRefresh.h"
#import "SolarTermModel.h"
#import "DetailViewController.h"
@interface SolarTermTableView ()
{
    NSMutableArray *_modelData;
    CGFloat _contentOffsetY;
}

@end

@implementation SolarTermTableView
#define solarTermCell @"SolarTermCell"

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
        
        
        [self registerClass:[SolarTermCell class] forCellReuseIdentifier:solarTermCell];
        //设置偏移
        self.contentInset =  UIEdgeInsetsMake(0, 0, -49, 0);
        
        _modelData = [NSMutableArray array];
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.modelArray.count == 0) {
        self.tableHeaderView.hidden = YES;
    }
    else{
        self.tableHeaderView.hidden = NO;
    }
    return self.modelArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SolarTermCell *cell = [tableView dequeueReusableCellWithIdentifier:solarTermCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = _modelArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.isUnNormal = NO;
    detailVC.model = _modelArray[indexPath.row];
    detailVC.type = @"season";
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kScreenWidth*0.75;
    return height;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"offset---scroll:%f",self.contentOffset.y);
    if (_contentOffsetY - self.contentOffset.y > 0) {
        if (self.viewController.navigationController.navigationBar.alpha > 0.9) {
            self.viewController.navigationController.navigationBar.alpha = 1;
        }
        else{
            self.viewController.navigationController.navigationBar.alpha = (_contentOffsetY - self.contentOffset.y)/64;
        }
    }
    else{
        if (self.viewController.navigationController.navigationBar.alpha < 0.2) {
            self.viewController.navigationController.navigationBar.alpha = 0.01;
        }
        else{
            NSLog(@"%f",(_contentOffsetY - self.contentOffset.y)/100);
            self.viewController.navigationController.navigationBar.alpha = (_contentOffsetY - self.contentOffset.y)/100 + 1.5;
            if (self.viewController.navigationController.navigationBar.alpha <0.1) {
                self.viewController.navigationController.navigationBar.alpha = 0.01;
            }
        }
        
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //NSLog(@"%f",self.contentOffset.y);
    _contentOffsetY = self.contentOffset.y;
}


@end
