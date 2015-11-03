//
//  WriteNoteController.m
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "WriteNoteController.h"

@interface WriteNoteController ()<UITextViewDelegate>
{
    UITextView *_textView;
    UILabel *_rLabel;
}
@end

@implementation WriteNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _setNavItem];
    
    [self _createTextView];
}

-(void)_setNavItem
{
    UIButton *lBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lBtn.frame = CGRectMake(0, 0, 40, 40);
    UILabel *lLabel = [[UILabel alloc] initWithFrame:lBtn.bounds];
    lLabel.textColor = [UIColor blueColor];
    lLabel.text = @"取消";
    [lBtn addSubview:lLabel];
    [lBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:lBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rBtn.frame = CGRectMake(0, 0, 40, 40);
    _rLabel = [[UILabel alloc] initWithFrame:rBtn.bounds];
    _rLabel.text = @"完成";
    [rBtn addSubview:_rLabel];
    [rBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)send
{
    if (!_isUnnormal) {
        if (_textView.text.length!=0) {
            
            NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/club/add_note"];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"POST";
            
            NSString *bodyText = [NSString stringWithFormat:@"token=668347be401c6500aea15598fbce8fab&content=%@",_textView.text];
            request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteSendSussceed" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }
    else{
        if (_textView.text.length!=0) {
            
            NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/comment/add"];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"POST";
            
            NSString *bodyText = [NSString stringWithFormat:@"article_id=%@&content=%@&url=http://api.ilohas.com/comment/add&token=668347be401c6500aea15598fbce8fab&category=%@",_articleID,_textView.text,_type];
            request.HTTPBody = [bodyText dataUsingEncoding:NSUTF8StringEncoding];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteSendSussceed" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_createTextView
{
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [_textView becomeFirstResponder];
    _textView.delegate = self;
    [self.view addSubview:_textView];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        _rLabel.textColor = [UIColor blueColor];
    }
    else{
        _rLabel.textColor = [UIColor blackColor];
    }
    NSLog(@"%li",textView.text.length);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_textView resignFirstResponder];
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
