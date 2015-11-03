//
//  RecommendViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendTableView.h"
#import "RecommendTableViewCell.h"
#import "MJRefresh.h"

@interface RecommendViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIScrollViewDelegate>
{
    RecommendTableView *_recommendTableView;
    NSMutableData *_receiveData;
    NSMutableArray *_dataArray;
    //  UIScrollView *_scrollView;
    //  UIImageView *_topImageView;
    UIView *_view;
    UIActivityIndicatorView *_activityView;
    UIPageControl *_pageControl;
    BOOL _isFirstPape;
}

@end

@implementation RecommendViewController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTableView];
    
    [self _loadURL];
    
    _dataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ContentOffsetSet) name:kViewControllerChanged object:nil];
    
}

- (void)_createTableView {
    
    _recommendTableView = [[RecommendTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_recommendTableView];
    
    //    //添加头视图
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.75)];
    //
    _topImageView = [[TopImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.75)];
    
    _topImageView.delegate = self;
    
    _recommendTableView.tableHeaderView = _view;
    [_view addSubview:_topImageView];
    [self _creatActivityIndicatorView];
    [self _createPageControl];
    
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
    
    
    [_recommendTableView reloadData];
    
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

#pragma mark -加载更多

-(void)previous
{
    _isFirstPape = YES;
    [_topImageView _loadURL];
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/daily"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = @"page=1&pagesize=10";
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [_recommendTableView.header endRefreshing];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self _showAlert];
            });
            return;
        }
        NSData *resData = [[NSData alloc] initWithData:data];
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
        
        [_dataArray removeAllObjects];
        
        [self loadData:dic];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_recommendTableView.header endRefreshing];
            [_recommendTableView reloadData];
        });
        
        
    }];
    
    
}

-(void)next
{
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/daily"];
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
            [_recommendTableView.footer endRefreshing];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self _showAlert];
            });
            return;
        }
        NSData *resData = [[NSData alloc] initWithData:data];
        
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
        
        [self loadData:dic];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_recommendTableView.footer endRefreshing];
            
            [_recommendTableView reloadData];
        });
        
        
    }];
}

-(void)_showAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
}


- (void)_loadURL {
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/daily"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body = @"page=1&pagesize=10";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [_activityView stopAnimating];
    [self _showAlert];
    _recommendTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
    _recommendTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(next)];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _receiveData = [[NSMutableData alloc] init];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [_activityView stopAnimating];
    _recommendTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
    _recommendTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(next)];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
    
    [self loadData:dictionary];
    _pageControl.hidden = NO;
}

- (void)loadData:(NSDictionary *)dictionary {
    
    NSArray *arr = dictionary[@"content"];
    for (NSDictionary *dic in arr) {
        RecommendModel *model = [[RecommendModel alloc] initWithDataDic:dic];
        [_dataArray addObject:model];
        
    }
    
    _recommendTableView.modelArray = _dataArray;
    
    
    [_recommendTableView reloadData];
    
}


#pragma mark -通知方法
-(void)ContentOffsetSet
{
    [_recommendTableView setContentOffset:CGPointMake(0, -64) animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
}

@end
