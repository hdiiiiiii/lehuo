//
//  LeftViewController.h
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;
    NSArray *_rowTitles;
    
}

@end
