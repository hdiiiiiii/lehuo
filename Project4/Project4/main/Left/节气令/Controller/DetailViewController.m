//
//  DetailViewController.m
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "DetailViewController.h"
#import "MyhomeViewController.h"
#import "ShareView.h"
#import "AppDelegate.h"

@interface DetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    UIWebView *_webView;
    
    UIView *_bottomView;
    
    UIActivityIndicatorView *_activityView;
    
    NSMutableData *_receiveData;
    
    ShareView *_shareview;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.alpha = 1;
//    self.navigationController.navigationBar.frame = CGRectMake(0, -64, kScreenWidth, 44);
    //self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:224.0f/255.0f blue:206.0f/255.0f alpha:1];
    if (!_isUnNormal) {
        [self _createDetailsView];
    }
    else{
        [self _loadURL];
    }
}

-(void)setNavItem
{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 40, 40);
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
}

-(void)_loadURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.ilohas.com/%@/%@",_type,_model.idStr]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
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
    [_activityView stopAnimating];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
    [self _loadData:dic];
    
}

-(void)_loadData:(NSDictionary *)dictionary
{
    
    SolarTermModel *model = [[SolarTermModel alloc] initWithDataDic:dictionary[@"content"]];
    self.model = model;
    
    [self _createDetailsView];
}

-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.frame = CGRectMake(0, -64, kScreenWidth, 44);
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.frame = CGRectMake(0, -64, kScreenWidth, 44);
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationController.navigationBarHidden = NO;
//    });
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//加载菊花图
-(void)_creatActivityIndicatorView
{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth/2-25, kScreenHeight/2-30, 50, 50)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:_activityView];
    [_activityView startAnimating];
}


- (void)_createDetailsView {
    self.tabBarController.tabBar.hidden = YES;
    
    //imageView创建
    if (self.model.cover_small == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    else{
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    }
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:self.model.cover_small]];
    _imageView.layer.masksToBounds = YES;
    _imageView.hidden = NO;
    
    //webview创建
    if (_webView == nil) {
        
    }
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, _imageView.bounds.size.height, kScreenWidth, kScreenHeight)];
    _webView.delegate = self;
    
    _webView.scalesPageToFit = YES;
    _webView.contentMode = UIViewContentModeScaleAspectFit;
    _webView.scrollView.scrollEnabled = NO;

    NSString *str = self.model.content;
    
    NSMutableString *htmlStr = [[NSMutableString alloc] initWithFormat:@"%@",str];
    [htmlStr appendString:@"<html>"];
    [htmlStr appendString:@"<head>"];
    [htmlStr appendString:@"<meta charset=\"utf-8\">"];
    [htmlStr appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [htmlStr appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [htmlStr appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [htmlStr appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [htmlStr appendString:@"<style>img{width:100%;}</style>"];
    [htmlStr appendString:@"<style>table{width:100%;}</style>"];
    [htmlStr appendString:@"<title>webview</title>"];
    
    
    [_webView loadHTMLString:htmlStr baseURL:nil];
    _webView.userInteractionEnabled = NO;
    
    [_webView setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:224.0f/255.0f blue:206.0f/255.0f alpha:1]];
    
    [_webView setOpaque:NO];
    
    
    //scrollerview创建
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -44, kScreenWidth,kScreenHeight+44)];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth, _webView.bounds.size.height);
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    [_scrollView addSubview:_webView];
    
    [_scrollView addSubview:_imageView];
    
    [self.view addSubview:_scrollView];
    
    //加菊花
    [self _creatActivityIndicatorView];
    
    //底部视图创建
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 45)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        
        CGFloat width = (kScreenWidth-120)/5;
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, 30, 45)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"aico_return@2x"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnComment = [[UIButton alloc] initWithFrame:CGRectMake(width*2+30, 0, 30, 45)];
        [btnComment setBackgroundImage:[UIImage imageNamed:@"aico_comment@2x"] forState:UIControlStateNormal];
        [btnComment addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnFavorite = [[UIButton alloc] initWithFrame:CGRectMake(width*3+30*2, 0, 30, 45)];
        [btnFavorite setBackgroundImage:[UIImage imageNamed:@"aico_favorite@2x"] forState:UIControlStateNormal];
        [btnFavorite setBackgroundImage:[UIImage imageNamed:@"aico_favoriteSelect@2x"] forState:UIControlStateSelected];
        [btnFavorite addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(width*4+30*3, 0, 30, 45)];
        [btnShare setBackgroundImage:[UIImage imageNamed:@"aico_share@2x"] forState:UIControlStateNormal];
        [btnShare addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_bottomView addSubview:btnBack];
        [_bottomView addSubview:btnComment];
        [_bottomView addSubview:btnFavorite];
        [_bottomView addSubview:btnShare];
        
        
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/add"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/add&token=668347be401c6500aea15598fbce8fab&category=%@",self.model.idStr,self.type];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                return;
            }
            NSData *resData = [[NSData alloc] initWithData:data];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dic);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([dic[@"error"] isEqualToString:@"该条目已收藏"]) {
                    btnFavorite.selected = YES;
                }
                else if ([dic[@"content"] isEqualToString:@"收藏成功"])
                {
                    NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/delete"];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                    request.HTTPMethod = @"POST";
                    NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/delete&token=668347be401c6500aea15598fbce8fab&category=%@",self.model.idStr,self.type];
                    request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
                    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        nil;
                    }];
                }
            });
        }];
        
    }
    
}
#pragma mark -按钮方法
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commentAction
{
    MyhomeViewController *home = [[MyhomeViewController alloc] init];
    home.urlStr = @"http://api.ilohas.com/comment/list";
    home.bodyStr = [NSString stringWithFormat:@"article_id=%@&url=http://api.ilohas.com/comment/list&category=%@&pagesize=10",_model.idStr,_type];
    home.type = _type;
    home.title = @"评论";
    home.articleID = _model.idStr;
    home.isUnnormal = YES;
    [self.navigationController pushViewController:home animated:YES];
    
    
}

-(void)favoriteAction:(UIButton *)btn
{
    if (!btn.selected) {
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/add"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/add&token=668347be401c6500aea15598fbce8fab&category=%@",self.model.idStr,self.type];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                return;
            }
            NSData *resData = [[NSData alloc] initWithData:data];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([dic[@"content"] isEqualToString:@"收藏成功"]) {
                    btn.selected = YES;
                    NSLog(@"收藏成功");
                }
                else{
                    NSLog(@"收藏失败");
                }
                
            });
        }];
    }
    
    else{
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/delete"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/delete&token=668347be401c6500aea15598fbce8fab&category=%@",self.model.idStr,self.type];
        request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                return;
            }
            NSData *resData = [[NSData alloc] initWithData:data];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([dic[@"content"] isEqualToString:@"删除成功"]) {
                    btn.selected = NO;
                    NSLog(@"删除成功");
                }
                else{
                    NSLog(@"删除失败");
                }
                
            });
        }];
        
    }
    
    
}



-(void)shareAction
{
    NSLog(@"分享");
    
    if (_shareview != nil){
        _shareview = nil;
    }
    
    _shareview = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _shareview.type = self.type;
    _shareview.itemId = _model.idStr;
    //[self.view addSubview:_shareview];
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate.window.rootViewController.view addSubview:_shareview];
    
    
}

#pragma mark -webview代理方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"%@",error);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_activityView stopAnimating];
    
    CGFloat scrollHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    CGFloat height = scrollHeight;
    CGRect frame = webView.frame;
    webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    if (_isUnNormal) {
        _scrollView.contentSize = CGSizeMake(kScreenWidth, height+264);
    }
    else{
        _scrollView.contentSize = CGSizeMake(kScreenWidth, height+215);
    }
}



#pragma mark -点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击了");
    if (_bottomView.frame.origin.y == kScreenHeight-45) {
        [UIView animateWithDuration:0.2 animations:^{
            _bottomView.transform = CGAffineTransformMakeTranslation(0, 45);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _bottomView.transform = CGAffineTransformMakeTranslation(0, -45);
        }];
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
