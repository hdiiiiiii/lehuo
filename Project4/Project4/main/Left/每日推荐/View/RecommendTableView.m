//
//  RecommendTableView.m
//  Project4
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "RecommendTableView.h"
#import "RecommendTableViewCell.h"
#import "UIView+UIViewController.h"
#import "DetailViewController.h"
@interface RecommendTableView ()
{
    CGFloat _contentOffsetY;
}

@end

@implementation RecommendTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
        [self registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"recommendCell"];
        self.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    }
    return self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendCell" forIndexPath:indexPath];
    
    cell.model = _modelArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //日期标签
    
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 40, 55)];
    imageView.image = [UIImage imageNamed:@"img_bookmark@2x"];
    [cell addSubview:imageView];
    
    UILabel *mothLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 40, 20)];
    mothLabel.backgroundColor = [UIColor clearColor];
    mothLabel.text = [self getDataLineText:indexPath][0];
    mothLabel.textColor = [UIColor whiteColor];
    mothLabel.textAlignment = NSTextAlignmentCenter;
    mothLabel.font = [UIFont systemFontOfSize:15 weight:.4];
    [imageView addSubview:mothLabel];
    
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, 40, 16)];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.text = [self getDataLineText:indexPath][1];
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.font = [UIFont systemFontOfSize:13 weight:.2];
    [imageView addSubview:dayLabel];
    
    
    [self getDataLineText:indexPath];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kScreenWidth*0.75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.isUnNormal = NO;
    detailVC.model = _modelArray[indexPath.row];
    detailVC.type = @"daily";
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}


//时间戳的计算

- (NSArray *)getDataLineText:(NSIndexPath *)indexPath {
    
    RecommendModel *model = self.modelArray[indexPath.row];
    NSString *time = model.dateline;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    //获取月份和日期
    [dateformatter setDateFormat:@"MM"];
    NSString *monthString=[dateformatter stringFromDate:date];
    [dateformatter setDateFormat:@"dd"];
    NSString *dayString=[dateformatter stringFromDate:date];
    
    NSDictionary *monthDic = @{
                               @"01":@"Jan",
                               @"02":@"Feb",
                               @"03":@"Mar",
                               @"04":@"Apr",
                               @"05":@"May",
                               @"06":@"Jun",
                               @"07":@"Jul",
                               @"08":@"Aug",
                               @"09":@"Sep",
                               @"10":@"Oct",
                               @"11":@"Nov",
                               @"12":@"Dec"
                              
                               };
    
    
    NSString *monStr = monthDic[monthString];
    
    NSArray *arr = [NSArray array];
    
    arr = @[monStr,dayString];
    
    
    return arr;
    
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
//            _contentOffsetY = _contentOffsetY + 64;
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
