//
//  MagazineDetailsCell.m
//  Project4
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineDetailsCell.h"
#import "MBProgressHUD.h"
@implementation MagazineDetailsCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _createViews];
    }
    return self;
}

- (void)_createViews {
    
    _imageView = [[UIImageView  alloc] initWithFrame:self.bounds];
    //_imageView.contentMode=UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    _scrollerView = [[UIScrollView alloc] initWithFrame:self.bounds];
    //取消反弹
    _scrollerView.bounces = NO;
    _scrollerView.maximumZoomScale = 3;
    _scrollerView.minimumZoomScale = 1;
    _scrollerView.delegate = self;
    [_scrollerView addSubview:_imageView];
    [self addSubview:_scrollerView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
    
    [self addGestureRecognizer:longPress];
    
    
    UITapGestureRecognizer *enlargeGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeAction)];
    enlargeGR.numberOfTapsRequired = 2;
    enlargeGR.numberOfTouchesRequired = 1;
    
    [self addGestureRecognizer:enlargeGR];
    
    
    
}


#pragma mark - 图片保存
- (void)savePhoto:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"savePhoto");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        
        [alert show];
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%li",buttonIndex);
    
    if (buttonIndex == 1) {
        
        
        UIImage *image = self.imageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

//保存完毕以后执行的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"大图保存完毕处理");
    //提示保存成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
    
}


- (void)enlargeAction {
    
    if (_scrollerView.zoomScale>1) {
        [_scrollerView setZoomScale:1 animated:YES];
    }
    else {
        [_scrollerView setZoomScale:2 animated:YES];
    }

}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageView;
}



- (void)setModel:(MagazineDetailsModel *)model {
    
    if (_model != model) {
        _model = model;

        
    }
}


-(void)backImageZoomingScale{
    
    [_scrollerView setZoomScale:1];
}


@end
