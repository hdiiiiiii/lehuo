//
//  CatalogueTableView.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CatalogueTableView.h"
#import "CatalogueCell.h"
#import "UIView+UIViewController.h"

@interface CatalogueTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@end

@implementation CatalogueTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
        [self registerClass:[CatalogueCell class] forCellReuseIdentifier:@"CatalogueCell"];
    }
    return self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _catalogueArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CatalogueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatalogueCell" forIndexPath:indexPath];
    
    NSDictionary *dic = _catalogueArray[indexPath.row];
    
    NSString *urlStr = dic[@"icon"];
    NSURL *url = [NSURL URLWithString:urlStr];
    [cell.headImageView sd_setImageWithURL:url];
    cell.labelText.text = dic[@"title"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = _catalogueArray[indexPath.row];
    
    NSString *strPage = dic[@"page"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRR" object:strPage];
    
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    
    
    
  
    
    NSLog(@"跳页");
}



@end
