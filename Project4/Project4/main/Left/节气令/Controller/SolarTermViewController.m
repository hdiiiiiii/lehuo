//
//  SolarTermViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "SolarTermViewController.h"
#import "SolarTermTableView.h"
#import "SolarTermModel.h"
#import "MJRefresh.h"
#import "TopImageView.h"
@interface SolarTermViewController ()<UIScrollViewDelegate>
{
    SolarTermTableView *_tableView;
    NSMutableData *_receiveData;
    NSMutableArray *_dataArray;
    UIActivityIndicatorView *_activityView;
    UIPageControl *_pageControl;
    UIView *_view;
    BOOL _isFirstPape;
}
@end

@implementation SolarTermViewController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    [self _createTableView];
    [self _loadURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ContentOffsetSet) name:kViewControllerChanged object:nil];
    
}
-(void)_createTableView
{
    _tableView = [[SolarTermTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.75)];
    
    _topImageView = [[TopImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.75)];
    
    _topImageView.delegate = self;
    
    [_view addSubview:_topImageView];
    _tableView.tableHeaderView = _view;
    
    [self.view addSubview:_tableView];
    [self _creatActivityIndicatorView];
    [self _createPageControl];
    //[_tableView reloadData];
}

#pragma mark - 创建PageControl
- (void)_createPageControl {
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _view.bounds.size.height - 30, kScreenWidth, 30)];
    
    //常用的属性
    _pageControl.numberOfPages = 7;
    
    //_pageControl.backgroundColor = [UIColor darkGrayColor];
    
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    [_pageControl addTarget:self
                     action:@selector(pageCon:) forControlEvents:UIControlEventValueChanged];
    _pageControl.hidden = YES;
    
    [_view addSubview:_pageControl];
    
    
    [_tableView reloadData];
    
}

-(void)pageCon :(UIPageControl *)sender {
    
    // NSLog(@"%ld",sender.currentPage);
    // 点击pageCoontrol时，scrollView切换到对应图片
    NSInteger index = sender.currentPage;
    
    // 计算scrollView的偏移量
    CGFloat contentOffsetX = index * kScreenWidth;
    
    CGPoint Off = CGPointMake(contentOffsetX, 0);
    
    // 滚动视图设置偏移量
    
    [_topImageView setContentOffset:Off animated:YES];
    
}
#pragma mark - 结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取最终的偏移量
    CGFloat offX = scrollView.contentOffset.x;
    
    //计算当前的页数
    NSInteger index =  offX / kScreenWidth;
    
    //修改pageControl的currentPage
    _pageControl.currentPage = index;
    
    
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
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/season"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = @"page=1&pagesize=10";
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
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/season"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    static int i = 1;
    if (_isFirstPape) {
        i = 1;
        _isFirstPape = NO;
    }
    i = i + 1;
    NSString *bodyText = [NSString stringWithFormat:@"page=%i&pagesize=10",i];
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [_tableView.footer endRefreshing];
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
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/season"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = @"page=1&pagesize=10";
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
    _pageControl.hidden = NO;
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
        SolarTermModel *model = [[SolarTermModel alloc] initWithDataDic:dic];
        [_dataArray addObject:model];
    }
    _tableView.modelArray = _dataArray;
    
    [_tableView reloadData];
    
}

#pragma mark -通知方法
-(void)ContentOffsetSet
{
    [_tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
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
