//
//  WebViewController.m
//  Project4
//
//  Created by apple on 15/10/28.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *webView;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self _setNavCItem];
    [self _createWebView];
}


-(void)_setNavCItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    
    UILabel *label = [[UILabel alloc] initWithFrame:btn.bounds];
    label.text = @"取消";
    label.textColor = [UIColor blueColor];
    
    [btn addSubview:label];
    
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)_createWebView {
    
    webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSURL *url=[NSURL URLWithString:_urlStr];
    webView.scalesPageToFit=YES;
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:request];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 40, 30);
//    [button setBackgroundImage:[UIImage imageNamed:@"ico_return@2x"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = left;
    
    
    
}


- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
