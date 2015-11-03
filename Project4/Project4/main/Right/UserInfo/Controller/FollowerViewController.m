//
//  FollowerViewController.m
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "FollowerViewController.h"
#import "FollowerModel.h"
#import "FollowerTableView.h"
#import "MJRefresh.h"

//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FollowerViewController ()
{
    NSMutableData *_receiveData;
    NSMutableArray *_dataArray;
    
    FollowerTableView *_tableView;
    
    UIActivityIndicatorView *_activityView;
    
    BOOL _isFirstPage;
}
@end

@implementation FollowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavItem];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self _createTableView];
    
    [self _loadURL];
}


-(void)setNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_return@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_createTableView
{
    _tableView = [[FollowerTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    [self _creatActivityIndicatorView];
}


//加载菊花图
-(void)_creatActivityIndicatorView
{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth/2-25, kScreenHeight/2-64, 50, 50)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
}


-(void)previous
{
    _isFirstPage = YES;
    if (!_isfans) {
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/follow_list"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        NSString *bodyText = [NSString stringWithFormat:@"myuid=5281&uid=%@&url=http://api.ilohas.com/club/follow_list&pagesize=15&page=1",_uid];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                [_tableView.header endRefreshing];
                
                return;
            }
            NSData *resData = [[NSData alloc] initWithData:data];
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
            
            [_dataArray removeAllObjects];
            
            [self _loadData:dic];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_tableView.header endRefreshing];
                [_tableView reloadData];
            });
            
            
        }];
    }
    else{
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/fans_list"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        NSString *bodyText = [NSString stringWithFormat:@"myuid=5281&uid=%@&url=http://api.ilohas.com/club/fans_list&pagesize=15&page=1",_uid];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                [_tableView.header endRefreshing];
                
                return;
            }
            NSData *resData = [[NSData alloc] initWithData:data];
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
            
            [_dataArray removeAllObjects];
            
            [self _loadData:dic];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_tableView.header endRefreshing];
                [_tableView reloadData];
            });
            
            
        }];
    }
    
    
}

-(void)next
{
    if (!_isfans) {
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/follow_list"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        static int i = 1;
        if (_isFirstPage) {
            i = 1;
        }
        i = i + 1;
        NSString *bodyText = [NSString stringWithFormat:@"myuid=5281&uid=%@&url=http://api.ilohas.com/club/follow_list&pagesize=15&page=%i",_uid,i];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                [_tableView.footer endRefreshing];
                
                return;
            }
            NSData *resData = [[NSData alloc] initWithData:data];
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
            
            [self _loadData:dic];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_tableView.footer endRefreshing];
                
                [_tableView reloadData];
            });
            
            
        }];
    }
    else{
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/fans_list"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        static int i = 1;
        if (_isFirstPage) {
            i = 1;
        }
        i = i + 1;
        NSString *bodyText = [NSString stringWithFormat:@"myuid=5281&uid=%@&url=http://api.ilohas.com/club/fans_list&pagesize=15&page=%i",_uid,i];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                [_tableView.footer endRefreshing];
                
                return;
            }
            NSData *resData = [[NSData alloc] initWithData:data];
            
            NSError *error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
            
            [self _loadData:dic];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_tableView.footer endRefreshing];
                
                [_tableView reloadData];
            });
            
            
        }];
    }
    
}


-(void)_loadURL
{
    if (!_isfans) {
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/follow_list"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        NSString *bodyText = [NSString stringWithFormat:@"myuid=5281&uid=%@&url=http://api.ilohas.com/club/follow_list&pagesize=15&page=1",_uid];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else{
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/fans_list"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        NSString *bodyText = [NSString stringWithFormat:@"myuid=5281&uid=%@&url=http://api.ilohas.com/club/fans_list&pagesize=15&page=1",_uid];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

//网络请求失败会调用的协议方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络请求失败：%@",error);
    [_activityView stopAnimating];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
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
    [_activityView stopAnimating];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(next)];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
    
    [self _loadData:dic];
    
    
}
-(void)_loadData:(NSDictionary *)dictionary
{
    
    NSArray *dataArray = dictionary[@"content"];
    for (NSDictionary *dic in dataArray) {
        FollowerModel *model = [[FollowerModel alloc] initWithDataDic:dic];
        [_dataArray addObject:model];
    }
    _tableView.modelArray = _dataArray;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
