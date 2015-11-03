//
//  MagazineViewController.m
//  Project4
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineViewController.h"
#import "RecommendViewController.h"
#import "MagazineCollectionView.h"
#import "MagazineModel.h"
#import "MagazineCell.h"
#import "MagazineDetailsView.h"
#import "MJRefresh.h"

@interface MagazineViewController ()
{
    MagazineCollectionView *_collectionView;
    NSMutableData *_receiveData;
    NSMutableArray *_dataArray;
 
    UIActivityIndicatorView *_activityView;
    
    BOOL _isFirstPape;
    
}
@end

@implementation MagazineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    [self _navItemSet];
    
    [self _createCollection];
    
     [self _creatActivityIndicatorView];
    
    [self _loadURL];
    
   
}

-(void)_navItemSet
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 38, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"ico_return@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 150)];
//    [self.view addSubview:imageV];
//    
//    [imageV sd_setImageWithURL:[NSURL URLWithString:@"http://img.ilohas.com/upload/1509/11/174905968355f28f7e60ee05.50244328.jpg"]];
    
    
}

-(void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNavButtonSelected object:@"1"];
}

-(void)_createCollection
{
    //布局
    UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
    flowLayou.minimumInteritemSpacing = 15;
    flowLayou.minimumLineSpacing = 10;
    CGFloat itemSize = (kScreenWidth - 50)/3;
    flowLayou.itemSize = CGSizeMake(itemSize, itemSize*16/9);
    flowLayou.sectionInset = UIEdgeInsetsMake(10, 10, -39, 10);
    flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    //创建
    _collectionView = [[MagazineCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayou];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[MagazineCell class] forCellWithReuseIdentifier:@"MagazineCell"];
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
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/magazine"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = @"pagesize=9&platform=1&page=1";
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [_collectionView.header endRefreshing];
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
            [_collectionView.header endRefreshing];
            [_collectionView reloadData];
        });
        
        
    }];
    
    
}

-(void)next
{
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/magazine"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    static int i = 1;
    if (_isFirstPape) {
        i = 1;
        _isFirstPape = NO;
    }
    i = i + 1;
    NSString *bodyText = [NSString stringWithFormat:@"pagesize=9&platform=1&page=%i",i];
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [_collectionView.footer endRefreshing];
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
            [_collectionView.footer endRefreshing];
            
            [_collectionView reloadData];
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




-(void)_loadURL
{
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/magazine"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = @"pagesize=9&platform=1&page=1";
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

//网络请求失败会调用的协议方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    NSLog(@"网络请求失败：%@",error);
    [_activityView stopAnimating];
    [self _showAlert];
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(next)];
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
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(previous)];
    _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(next)];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
    [self _loadData:dic];
    
}

-(void)_loadData:(NSDictionary *)dictionary
{
    NSArray *dataArray = dictionary[@"content"];
    for (NSDictionary *dic in dataArray) {
        MagazineModel *model = [[MagazineModel alloc] initWithDataDic:dic];

        [_dataArray addObject:model];
        }
    
    _collectionView.modelArray = _dataArray;
 
    
    [_collectionView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    _collectionView.magazineIDArray = [[NSUserDefaults standardUserDefaults] objectForKey:kMagazineID];
    if (_collectionView.magazineIDArray.count == 0) {
        [_collectionView reloadData];
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
