//
//  UserInfoTabelView.m
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "UserInfoTabelView.h"
#import "UserInfoCell.h"
#import "UserInfoModel.h"
#import "UIImageView+WebCache.h"
#import "UserTopView.h"

//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface UserInfoTabelView ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isCreate;
}

@end

@implementation UserInfoTabelView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:236/255.0 green:244/255.0 blue:1 alpha:1];
        self.contentInset = UIEdgeInsetsMake(0, 0, -69, 0);
        self.allowsSelection = NO;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[UserInfoCell class] forCellReuseIdentifier:@"UserInfoCell"];
        
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.modelArray!=nil) {
        if (!_isCreate) {
            _isCreate = YES;
            UserTopView *view = [[UserTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
            //UserInfoModel *model = _modelArray[0];
            view.uid = _uid;
            
            self.tableHeaderView = view;
        }
    }
    
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UserInfoModel *model = self.modelArray[indexPath.row];
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
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
    contentLabelSize = [self labelsize:dic[@"content"]];
    cell.contentLabel.frame = CGRectMake(40, 35, kScreenWidth-80,contentLabelSize.height);
    cell.contentLabel.text = dic[@"content"];
    
    
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
    UserInfoModel *model = self.modelArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@",model.content];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    CGSize contentLabelSize = [self labelsize:dic[@"content"]];
    return 35+contentLabelSize.height+20+18+10;
    
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



-(void)deleteNote:(UIButton *)sender
{
    UserInfoModel *model = _modelArray[sender.tag-10];
    NSMutableArray *deleteArray = [[NSMutableArray alloc] initWithArray:_modelArray];
    [deleteArray removeObjectAtIndex:(sender.tag - 10)];
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/delete_note"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = [NSString stringWithFormat:@"url=http://api.ilohas.com/club/delete_note&token=668347be401c6500aea15598fbce8fab&id=%@",model.noteID];
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

-(void)likeThis:(UIButton *)sender;
{
    sender.selected = YES;
    UserInfoModel *model = _modelArray[sender.tag];
    
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/add_note_like"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = [NSString stringWithFormat:@"url=http://api.ilohas.com/club/add_note_like&id=%@",model.noteID];
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

@end
