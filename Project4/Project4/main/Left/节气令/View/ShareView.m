//
//  ShareView.m
//  Project3
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "ShareView.h"
#import "AppDelegate.h"
@implementation ShareView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.2];
        [self _createbottom];
    }
    return self;
}


-(void)_createbottom
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -90, kScreenWidth, 90)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 101;
    UIButton *weiboBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    [weiboBtn setBackgroundImage:[UIImage imageNamed:@"sdk_weibo_logo@2x"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(shareWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:weiboBtn];
    [self addSubview:view];
    
    [UIView animateWithDuration:.2 animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, 90);
    }];
    
    
}

-(void)shareWeibo
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
        message.text = [NSString stringWithFormat:@"给大家推荐一篇好看的文章～http://web.ilohas.com/%@/%@",self.type,self.itemId];
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.y>-90) {
        UIView *view = (UIView *)[self viewWithTag:101];
        [UIView animateWithDuration:.2 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, -90);
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
