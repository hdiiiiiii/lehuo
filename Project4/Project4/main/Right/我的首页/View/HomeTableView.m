//
//  HomeTableView.m
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "HomeTableView.h"
#import "HomeTableViewCell.h"
#import "HomeModel.h"
#import "UserInfoViewController.h"
#import "UIView+UIViewController.h"
@interface HomeTableView ()<UITableViewDataSource,UITableViewDelegate>
@end
@implementation HomeTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        if (_isUnnormal) {
            self.contentInset = UIEdgeInsetsMake(0, 0, -69, 0);
            self.backgroundColor = [UIColor colorWithRed:236/255.0 green:244/255.0 blue:1 alpha:1];
        }
        else{
//            self.contentInset = UIEdgeInsetsMake(0, 0, -109, 0);
            self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
        }
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"HomeTableViewCell"];
    }
    return self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    cell.isUnnormal = _isUnnormal;
    cell.backgroundColor = [UIColor clearColor];
    HomeModel *model = self.modelArray[indexPath.row];
    cell.model = model;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    NSDictionary *attr = @{font:NSFontAttributeName
                           };
    CGSize nameSize = [model.username sizeWithAttributes:attr];
    cell.userNameLabel.frame = CGRectMake(40, 4, nameSize.width+10,20);
    cell.userNameLabel.text = model.username;
    
    NSString *time = [self getTime:model.dateline];
    cell.timeLabel.frame = CGRectMake(40+nameSize.width+10+10, 4, 150, 20);
    cell.timeLabel.text = time;
    
    NSString *str = [NSString stringWithFormat:@"%@",model.content];
    CGSize contentLabelSize;
    if (!_isUnnormal) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        contentLabelSize = [self labelsize:dic[@"content"]];
        cell.contentLabel.frame = CGRectMake(40, 35, kScreenWidth-80,contentLabelSize.height);
        cell.contentLabel.text = dic[@"content"];
    }
    else{
        contentLabelSize = [self labelsize:model.content];
        cell.contentLabel.frame = CGRectMake(40, 35, kScreenWidth-80,contentLabelSize.height);
        cell.contentLabel.text = model.content;
    }
    
    
    cell.heartBtn.frame = CGRectMake(40, 35+contentLabelSize.height+20, 21, 18);
    cell.heartBtn.tag = indexPath.row;
    [cell.heartBtn addTarget:self action:@selector(likeThis:) forControlEvents:UIControlEventTouchUpInside];
    cell.heartLabel.frame = CGRectMake(65, 35+contentLabelSize.height+20, 21, 18);
    cell.heartLabel.text = model.likes;
    
    cell.deletBtn.frame = CGRectMake(kScreenWidth-120, 35+contentLabelSize.height+20, 15, 18);
    [cell.deletBtn addTarget:self action:@selector(deleteNote:) forControlEvents:UIControlEventTouchUpInside];
    cell.deletBtn.tag = indexPath.row+10;
    if ([model.uid isEqualToString:@"5281"]) {
        cell.deletBtn.hidden = NO;
    }
    else{
        cell.deletBtn.hidden = YES;
    }
    cell.followsBtn.frame = CGRectMake(kScreenWidth-75, 35+contentLabelSize.height+20, 21, 18);
    cell.followsLabel.frame = CGRectMake(kScreenWidth-45, 35+contentLabelSize.height+20, 21, 18);
    cell.followsLabel.text = model.replies;
    
    cell.bottomView.frame = CGRectMake(4, 35+contentLabelSize.height+20+18+5, kScreenWidth-8, 1);
    return cell;
}

-(void)deleteNote:(UIButton *)sender
{
    if (!_isUnnormal) {
        HomeModel *model = _modelArray[sender.tag-10];
        NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithArray:_modelArray];
        [deleteArray removeObjectAtIndex:(sender.tag - 10)];
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/delete_note"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"url=http://api.ilohas.com/club/delete_note&token=668347be401c6500aea15598fbce8fab&id=%@",model.homeID];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _modelArray = deleteArray;
                [self reloadData];
            });
        }];
    }
    else{
        HomeModel *model = _modelArray[sender.tag-10];
        NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithArray:_modelArray];
        [deleteArray removeObjectAtIndex:(sender.tag - 10)];
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/comment/delete"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        NSString *bodyText = [NSString stringWithFormat:@"url=http://api.ilohas.com/comment/delete&token=668347be401c6500aea15598fbce8fab&id=%@",model.homeID];
        
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _modelArray = deleteArray;
                [self reloadData];
            });
        }];
    }
    
}

-(void)likeThis:(UIButton *)sender;
{
    sender.selected = YES;
    HomeModel *model = _modelArray[sender.tag];
    if (_isUnnormal) {
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/comment/add_like"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"url=http://api.ilohas.com/comment/add_like&id=%@",model.homeID];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *nowlikes = model.likes;
                NSInteger like = [nowlikes integerValue];
                model.likes = [NSString stringWithFormat:@"%li",like+1];
                [self reloadData];
            });
        }];
    }
    else{
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/add_note_like"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"url=http://api.ilohas.com/club/add_note_like&id=%@",model.homeID];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *nowlikes = model.likes;
                NSInteger like = [nowlikes integerValue];
                model.likes = [NSString stringWithFormat:@"%li",like+1];
                [self reloadData];
            });
        }];
    }
    
}


-(CGSize)labelsize:(NSString *)str
{
    CGSize size = CGSizeMake(kScreenWidth-80, 20000);
    NSDictionary *atttibutes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect fram = [str boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:atttibutes
                                    context:nil];
    return fram.size;
    
}

-(NSString *)getTime:(NSString *)timeSP
{
    NSInteger time = [timeSP integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    //获取月份和日期
    [dateformatter setDateFormat:@"YY"];
    NSString *yearString=[dateformatter stringFromDate:date];
    [dateformatter setDateFormat:@"MM"];
    NSString *monthString=[dateformatter stringFromDate:date];
    [dateformatter setDateFormat:@"dd"];
    NSString *dayString=[dateformatter stringFromDate:date];
    return [NSString stringWithFormat:@"20%@年%@月%@日",yearString,monthString,dayString];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *model = self.modelArray[indexPath.row];
    if (!_isUnnormal) {
        NSString *str = [NSString stringWithFormat:@"%@",model.content];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        CGSize contentLabelSize = [self labelsize:dic[@"content"]];
        return 35+contentLabelSize.height+20+18+10;
    }
    else {
        CGSize contentLabelSize = [self labelsize:model.content];
        return 35+contentLabelSize.height+20+18+10;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *model = _modelArray[indexPath.row];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    userInfoVC.uid = model.uid;
    [self.viewController.navigationController pushViewController:userInfoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
