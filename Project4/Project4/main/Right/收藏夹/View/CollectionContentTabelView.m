//
//  CollectionContentTabelView.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CollectionContentTabelView.h"
#import "CollectionModel.h"
#import "DetailViewController.h"
#import "SolarTermModel.h"
#import "UIView+UIViewController.h"
#import "MagazineDetailsViewController.h"
#import "MagazineModel.h"
@interface CollectionContentTabelView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CollectionContentTabelView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectionCell"];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(4, cell.bounds.size.height-1, kScreenWidth-8, 1)];
        bottomView.backgroundColor = [UIColor blackColor];
        [cell addSubview:bottomView];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    CollectionModel *model = _modelArray[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_type isEqualToString:@"magazine"]) {
        MagazineDetailsViewController *magazineVC = [[MagazineDetailsViewController alloc] init];
        MagazineModel *model =[[MagazineModel alloc] init];
        CollectionModel *cModel = _modelArray[indexPath.row];
        model.magazineID = cModel.item_id;
        magazineVC.magazineModel = model;
        
        [self.viewController presentViewController:magazineVC animated:YES completion:nil];
    }
    else{
        SolarTermModel *sModel = [[SolarTermModel alloc] init];
        CollectionModel *cModel = _modelArray[indexPath.row];
        sModel.idStr = cModel.item_id;
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.isUnNormal = YES;
        detailVC.model = sModel;
        detailVC.type = _type;
        
        [self.viewController.navigationController pushViewController:detailVC animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
