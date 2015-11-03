//
//  TopImageView.m
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "TopImageView.h"
#import "UIScrollView+Touch.h"
#import "MagazineModel.h"
#import "MagazineDetailsViewController.h"
#import "UIView+UIViewController.h"
#import "WebViewController.h"
#import "DetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TopImageView ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIScrollViewDelegate>
{
    UIImageView *_imageView;
    NSMutableData *_receiveData;
    NSMutableArray *_dataArray;

}

@end
@implementation TopImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //分页效果
        self.pagingEnabled = YES;
        //隐藏水平方向的滚动条
       // self.showsHorizontalScrollIndicator = NO;
        
        
          //  [self _createSubViews];
        
        [self _loadURL];
    
        
    }
    
    return self;
}





//-(void)_createSubViews {
//    
//    self.contentSize = CGSizeMake(kScreenWidth*_dataArray.count, kScreenWidth*0.75);
//    for (int i = 0; i < _dataArray.count; i++) {
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenWidth*0.75)];
//        _imageView.layer.borderWidth = 2;
//        _imageView.layer.borderColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1].CGColor;
//        _imageView.layer.cornerRadius = 5;
//        
//        NSURL *url = [NSURL URLWithString:_model.image];
//        
//        [_imageView sd_setImageWithURL:url];
//        
//        //_imageView.backgroundColor = [UIColor grayColor];
//        [self addSubview:_imageView];
//    }
//    
//    
//}



-(void)_loadURL
{
    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/banner_list"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyText = @"platform=1";
    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//网络请求失败会调用的协议方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络请求失败：%@",error);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receiveData = [[NSMutableData alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
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
   // [self _loadData:dic];
    NSArray *dataArray = dic[@"content"];
    
    for (NSDictionary *dictionary in dataArray) {
        TopViewModel *model = [[TopViewModel alloc] initWithDataDic:dictionary];
        
        [_dataArray addObject:model];
    }
    
    
    self.contentSize = CGSizeMake(kScreenWidth*_dataArray.count, kScreenWidth*0.75);
    for (int i = 0; i < _dataArray.count; i++) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenWidth*0.75)];
        _imageView.layer.borderWidth = 2;
        _imageView.layer.borderColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1].CGColor;
        _imageView.layer.cornerRadius = 5;
        _model = _dataArray[i];
        NSURL *url = [NSURL URLWithString:_model.image];
        
        [_imageView sd_setImageWithURL:url];
        
        //_imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:_imageView];
    
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_dataArray != nil) {
        
        
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        NSInteger indx = point.x/(kScreenWidth+10);
        _model = _dataArray[indx];
        
        
        
        if ([_model.type isEqualToString:@"magazine"]) {
            MagazineModel *model = [[MagazineModel alloc] init];
            model.magazineID = _model.url;
            MagazineDetailsViewController *magazineDetailVC = [[MagazineDetailsViewController alloc] init];
            magazineDetailVC.magazineModel = model;
            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:magazineDetailVC];
            
            [self.viewController presentViewController:navCon animated:YES completion:nil];
        }
        if ([_model.type isEqualToString:@"daily"]) {
            if (_model.content.length > 10) {
                DetailViewController *detailViewController = [[DetailViewController alloc] init];
                detailViewController.type = _model.type;
                detailViewController.model.idStr = _model.url;
                
                //            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:detailViewController];
                NSLog(@"%@",self.viewController.navigationController);
                [self.viewController.navigationController pushViewController:detailViewController animated:YES];
            }
        }
        
        if ([_model.type isEqualToString:@"website"]) {
            
            WebViewController *webView = [[WebViewController alloc] init];
            webView.urlStr = _model.url;
            
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webView];
            
            //            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:webView];
            
            
            [self.viewController presentViewController:navVC animated:YES completion:nil];        }
        
        if ([_model.type isEqualToString:@"video"]) {
            
            //NSString *urlStr = [NSString stringWithFormat:@"%@",_model.url];
            NSURL *url = [NSURL URLWithString:_model.url];
            MPMoviePlayerViewController *player=[[MPMoviePlayerViewController  alloc]initWithContentURL:url];
            
            [self.viewController presentViewController:player animated:YES completion:nil];
            
            
            
        }
        
        
    }
    
    
    
    
    //    [self.viewController.navigationController pushViewController:magazineDetailVC animated:YES];
    
    
}
//-(void)_loadData:(NSDictionary *)dictionary
//{
//    NSArray *dataArray = dictionary[@"content"];
//    for (NSDictionary *dic in dataArray) {
//        TopViewModel *model = [[TopViewModel alloc] initWithDataDic:dic];
//        [_dataArray addObject:model];
//    }
//
//    
//    
//    
//}

//-(void)pageAction:(UIPageControl *)sender {
//    
//    //    NSLog(@"%ld",sender.currentPage);
//    //点击pageCoontrol时，scrollView切换到对应图片
//    NSInteger index = sender.currentPage;
//    
//    //计算scrollView的偏移量
//    CGFloat contentOffsetX = index * kScreenWidth;
//    
//    CGPoint Off = CGPointMake(contentOffsetX, 0);
//    
//    //滚动视图设置偏移量
//    
//    [self setContentOffset:Off animated:YES];
//    
//    
//    
//    
//}
//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    
//
//  
//    
//}
/*
#pragma mark - 创建PageControl
_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _view.bounds.size.height - 30, kScreenWidth, 30)];

//常用的属性
_pageControl.numberOfPages = _topImageView.imageArray.count;
// _pageControl.backgroundColor = [UIColor darkGrayColor];

_pageControl.currentPage = 0;
_pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
_pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];

[_pageControl addTarget:self
                 action:@selector(pageCon:) forControlEvents:UIControlEventValueChanged];


[_view addSubview:_pageControl];


[_recommendTableView reloadData];

}

-(void)pageCon :(UIPageControl *)sender {
    
    //  NSLog(@"%ld",sender.currentPage);
    //点击pageCoontrol时，scrollView切换到对应图片
    NSInteger index = sender.currentPage;
    
    //计算scrollView的偏移量
    CGFloat contentOffsetX = index * kScreenWidth;
    
    CGPoint Off = CGPointMake(contentOffsetX, 0);
    
    //滚动视图设置偏移量
    
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
 
 */
@end
