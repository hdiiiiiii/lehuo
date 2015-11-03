//
//  RightViewController.h
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseViewController.h"

@interface RightViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView; //表视图
    UIView *_headView;      //头视图
    
    
    NSArray *_titleImages;
    NSArray *_titleNames;
    
}

@end
