//
//  MyhomeViewController.m
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MyhomeViewController.h"
#import "HomeTableView.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "WriteNoteController.h"

@interface MyhomeViewController ()
{
    HomeTableView *_tableView;
    NSMutableData *_receiveData;
    NSMutableArray *_dataArray;
    UIActivityIndicatorView *_activityView;
    
    BOOL _isFirstPape;
}
@end

@implementation MyhomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    self.navigationController.navigationBar.alpha = 1;
    
    if (_isUnnormal) {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
    }
    
    [self _setNavItem];
    
    [self _createTableView];
    
    [self _loadURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(previous) name:@"noteSendSussceed" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.alpha = 1;
}

-(void)_setNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_return@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (!_isUnnormal) {
        UIButton *Rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        Rbtn.frame = CGRectMake(0, 0, 20, 20);
        [Rbtn setBackgroundImage:[UIImage imageNamed:@"ico_write"] forState:UIControlStateNormal];
        [Rbtn addTarget:self action:@selector(writeNote) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:Rbtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
}

-(void)writeNote
{
    WriteNoteController *writeVC = [[WriteNoteController alloc] init];
    UINavigationController *writeNav = [[UINavigationController alloc] initWithRootViewController:writeVC];
    writeVC.isUnnormal = self.isUnnormal;
    writeVC.type = self.type;
    writeVC.articleID = self.articleID;
    [self presentViewController:writeNav animated:YES completion:nil];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)_createTableView
{
    _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.isUnnormal = self.isUnnormal;
    [self.view addSubview:_tableView];
    [self _creatActivityIndicatorView];
    
    if (_isUnnormal) {
        UIView *writeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 40)];
        writeView.layer.borderWidth = 1;
        writeView.layer.borderColor = [UIColor grayColor].CGColor;
        writeView.backgroundColor = [UIColor whiteColor];
        UIButton *textBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 30)];
        [textBtn addTarget:self action:@selector(writeNote) forControlEvents:UIControlEventTouchUpInside];
        
        textBtn.layer.cornerRadius = 5;
        textBtn.layer.borderWidth = 0.3;
        textBtn.layer.borderColor = [UIColor blackColor].CGColor;
        UIImageView *btnImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        btnImg.image = [UIImage imageNamed:@"ico_write"];
        UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 100, 20)];
        btnLabel.text = @"添加笔记";
        btnLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
        btnLabel.font = [UIFont systemFontOfSize:13];
        [textBtn addSubview:btnImg];
        [textBtn addSubview:btnLabel];
        [writeView addSubview:textBtn];
        
        [self.view addSubview:writeView];
    }
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
    _isFirstPape = YES;
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = [NSString stringWithFormat:@"page=1&%@",self.bodyStr];
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [_tableView.header endRefreshing];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self _showAlert];
            });
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

-(void)next
{
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    static int i = 1;
    if (_isFirstPape) {
        i = 1;
        _isFirstPape = NO;
    }
    i = i + 1;
    NSString *bodyText = [NSString stringWithFormat:@"page=%i&%@",i,self.bodyStr];
    
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [_tableView.footer endRefreshing];
            NSLog(@"%@",connectionError);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self _showAlert];
            });
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


-(void)_loadURL
{
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = [NSString stringWithFormat:@"page=1&%@",self.bodyStr];
    
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

-(void)_showAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
}

//网络请求失败会调用的协议方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络请求失败：%@",error);
    [_activityView stopAnimating];
    [self _showAlert];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(next)];
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
    if (!_isUnnormal) {
        NSArray *dataArray = dictionary[@"content"];
        for (NSDictionary *dic in dataArray) {
            HomeModel *model = [[HomeModel alloc] initWithDataDic:dic];
            [_dataArray addObject:model];
        }
        _tableView.modelArray = _dataArray;
        
        [_tableView reloadData];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@",dictionary[@"content"]];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dic in array) {
            HomeModel *model = [[HomeModel alloc] initWithDataDic:dic];
            [_dataArray addObject:model];
        }
        _tableView.modelArray = _dataArray;
        
        [_tableView reloadData];
    }
    
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
