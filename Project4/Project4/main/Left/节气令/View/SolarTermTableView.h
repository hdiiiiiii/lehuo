//
//  SolarTermTableView.h
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SolarTermTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *modelArray;
@end
