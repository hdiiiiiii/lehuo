//
//  CollectionContentController.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CollectionContentController.h"
#import "CollectionModel.h"
#import "CollectionContentTabelView.h"
#import "MJRefresh.h"

@interface CollectionContentController ()
{
    NSMutableData *_receiveData;
    NSMutableArray *_dataArray;
    CollectionContentTabelView *_collectionTableView;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation CollectionContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setNavItem];
    
    _dataArray = [NSMutableArray array];
    
    [self _createTableView];
    
    [self _loadURL];
}

-(void)_setNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 38, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"ico_return@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


//加载菊花图
-(void)_creatActivityIndicatorView
{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth/2-25, kScreenHeight/2-64, 50, 50)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
}


-(void)_createTableView
{
    _collectionTableView = [[CollectionContentTabelView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _collectionTableView.type = _type;
    
    [self.view addSubview:_collectionTableView];
}



-(void)previous
{
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/list"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";
    NSString *bodyText = [NSString stringWithFormat:@"pagesize=1000&platform=1&url=http://api.ilohas.com/favorite/list&token=668347be401c6500aea15598fbce8fab&category=%@",_type];
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [_collectionTableView.header endRefreshing];
            return;
        }
        NSData *resData = [[NSData alloc] initWithData:data];
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
        
        [_dataArray removeAllObjects];
        
        [self _loadData:dic];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_collectionTableView.header endRefreshing];
            [_collectionTableView reloadData];
        });
        
        
    }];
    
    
}

-(void)_loadURL
{
    [self _creatActivityIndicatorView];
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/list"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";
    NSString *bodyText = [NSString stringWithFormat:@"pagesize=1000&platform=1&url=http://api.ilohas.com/favorite/list&token=668347be401c6500aea15598fbce8fab&category=%@",_type];
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

//网络请求失败会调用的协议方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_activityView stopAnimating];
    _collectionTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
    NSLog(@"网络请求失败：%@",error);
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
    [_activityView stopAnimating];
    NSArray *array = dictionary[@"content"];
    NSString *str = [NSString stringWithFormat:@"%@",array];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    for (NSDictionary *dic in dataArray) {
        CollectionModel *model = [[CollectionModel alloc] initWithDataDic:dic];
        [_dataArray addObject:model];
    }
    
    _collectionTableView.modelArray = _dataArray;
    [_collectionTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
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
