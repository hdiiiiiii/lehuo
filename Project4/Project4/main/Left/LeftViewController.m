//
//  LeftViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "LeftViewController.h"
#import "RecommendViewController.h"
#import "SolarTermViewController.h"
#import "VideoFrequencyViewController.h"
#import "MagazineViewController.h"
#import "ShopViewController.h"
#import "AboutViewController.h"
@interface LeftViewController ()


@end

@implementation LeftViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    [self _loadData];
    
    [self _inieViews];
    
}

//初始化子视图
- (void)_inieViews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 300, kScreenHeight-40)];
    _tableView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    
    
    //创建头视图
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth*0.5, kScreenWidth*0.5*0.35)];
    // imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"logo2@2x"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _tableView.tableHeaderView = imageView;
    _tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    
}

- (void)_loadData {
    
    _rowTitles = @[@"每日推荐",@"节气令",@"好看视频",@"我的杂志",@"日子店"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _rowTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftCell"];
        
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.image = [UIImage imageNamed:@"rightcellbg2@2x"];
    
    
    
    cell.textLabel.text = _rowTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundView = imageView;
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:.6];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  //  cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[NSNotificationCenter defaultCenter] postNotificationName:kLeftTabbarSelected object:indexPath];
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
