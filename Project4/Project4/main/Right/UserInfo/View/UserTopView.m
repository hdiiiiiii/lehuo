//
//  UserTopView.m
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "UserTopView.h"
#import "UserTopModel.h"
#import "UIImageView+WebCache.h"
#import "FollowerViewController.h"
#import "UIView+UIViewController.h"

//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface UserTopView ()
{
    NSMutableData *_receiveData;
}

@end

@implementation UserTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setUid:(NSString *)uid
{
    if (_uid != uid) {
        _uid = uid;
        [self _loadUrl];
    }
}

-(void)_loadUrl
{
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/get_user_info"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *bodyText = [NSString stringWithFormat:@"url=http://api.ilohas.com/club/get_user_info&uid=%@",_uid];
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receiveData = [[NSMutableData alloc] init];
}
//获取数据会调用的协议方法
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}


//接受数据完毕会调用的协议方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
    [self _loadData:dic];
}
-(void)_loadData:(NSDictionary *)dictionary
{
    NSDictionary *dic = dictionary[@"content"];
    UserTopModel *model = [[UserTopModel alloc] initWithDataDic:dic];
    self.model = model;
    
    [self _createViews];
}

-(void)_createViews
{
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 45, 45)];
    iconImageView.layer.cornerRadius = 22;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    [self addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 18, 180, 20)];
    nameLabel.text = _model.username;
    [self addSubview:nameLabel];
    
    UILabel *noteCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    noteCountLabel.text = _model.note_total;
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 20)];
    noteLabel.text = @"笔记";
    noteLabel.font = [UIFont systemFontOfSize:12];
    
    UIButton *noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noteBtn.frame = CGRectMake(80, 48, 40, 40);
    [noteBtn addSubview:noteCountLabel];
    [noteBtn addSubview:noteLabel];
    [self addSubview:noteBtn];
    
    
    UILabel *followersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    followersCountLabel.text = _model.follows;
    UILabel *followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 20)];
    followersLabel.text = @"关注";
    followersLabel.font = [UIFont systemFontOfSize:12];
    
    UIButton *followersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followersBtn.frame = CGRectMake(160, 48, 40, 40);
    [followersBtn addSubview:followersCountLabel];
    [followersBtn addSubview:followersLabel];
    [followersBtn addTarget:self action:@selector(follwersAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:followersBtn];
    
    
    UILabel *fansCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    fansCountLabel.text = _model.fans;
    UILabel *fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 20)];
    fansLabel.text = @"粉丝";
    fansLabel.font = [UIFont systemFontOfSize:12];
    
    UIButton *fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fansBtn.frame = CGRectMake(240, 48, 40, 40);
    [fansBtn addSubview:fansCountLabel];
    [fansBtn addSubview:fansLabel];
    [fansBtn addTarget:self action:@selector(fansAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fansBtn];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(4, self.frame.size.height - 1, kScreenWidth - 8, 1)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:bottomView];
    
    
}

-(void)follwersAction
{
    FollowerViewController *followVC = [[FollowerViewController alloc] init];
    followVC.isfans = NO;
    followVC.uid = _model.uid;
    if ([_model.uid isEqualToString:@"5281"]) {
        followVC.title = @"我的关注";
    }
    else{
        followVC.title = @"他的关注";
    }
    [self.viewController.navigationController pushViewController:followVC animated:YES];
}

-(void)fansAction
{
    FollowerViewController *followVC = [[FollowerViewController alloc] init];
    followVC.isfans = YES;
    followVC.title = @"粉丝";
    followVC.uid = _model.uid;
    [self.viewController.navigationController pushViewController:followVC animated:YES];
}


@end
