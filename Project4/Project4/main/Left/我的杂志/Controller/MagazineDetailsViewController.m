//
//  MagazineDetailsViewController.m
//  Project4
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineDetailsViewController.h"
#import "MagazineDetailsView.h"
#import "MagazineDetailsCell.h"
#import "CatalogueViewController.h"
#import "BaseNavController.h"
#import "CatalogueTableView.h"
#import "MyhomeViewController.h"
#import "ShareView.h"
#import "AppDelegate.h"



@interface MagazineDetailsViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
   // CatalogueTableView *_tableView;
    MagazineDetailsView *_detalilsView;
    NSMutableData *_receiveData;
    NSMutableArray *_modelArray;
    UIView *_bottomView;
    BOOL _isHidden;
    NSMutableArray *_tableViewArr;
    
    ShareView *_shareview;
}

@end

@implementation MagazineDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _modelArray = [[NSMutableArray alloc] init];
    //self.view.backgroundColor = [UIColor whiteColor];
    [self _createCollectionView];
    [self _createBottomView];
    [self _createTapGestureRecognizer];
    [self _loadURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction:) name:@"changeRR" object:nil];
    
}

- (void)changeAction:(NSNotification *)notification {
    
    NSInteger index = [notification.object integerValue];
    
    CGFloat contentOffsetX = (index-1) * (kScreenWidth + 10);
    
    CGPoint offx = CGPointMake(contentOffsetX, 0);
    
    
    [_detalilsView setContentOffset:offx animated:YES];
    
    

    
}


- (void)_createBottomView{
    //底部视图创建
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-38, kScreenWidth, 38)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.alpha = 0.8;
       // [self.view addSubview:_bottomView];
        _isHidden = NO;
        CGFloat width = kScreenWidth/5;
        
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake((width-30)/2, 5, 33, 28)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"ico_return@2x"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnComment = [[UIButton alloc] initWithFrame:CGRectMake((width-30)/2+width, 5, 33, 28)];
        [btnComment setBackgroundImage:[UIImage imageNamed:@"ico_comment"] forState:UIControlStateNormal];
        [btnComment addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnFavorite = [[UIButton alloc] initWithFrame:CGRectMake((width-30)/2+width*2, 5, 33, 28)];
        [btnFavorite setBackgroundImage:[UIImage imageNamed:@"ico_favoriteline@2x"] forState:UIControlStateNormal];
        [btnFavorite setBackgroundImage:[UIImage imageNamed:@"ico_favorite@2x"] forState:UIControlStateSelected];
        [btnFavorite addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake((width-30)/2+width*3, 5, 33, 28)];
        [btnShare setBackgroundImage:[UIImage imageNamed:@"ico_share@2x"] forState:UIControlStateNormal];
        [btnShare addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *btnCatalogue = [[UIButton alloc] initWithFrame:CGRectMake((width-30)/2+width*4, 5, 33, 28)];
        [btnCatalogue setBackgroundImage:[UIImage imageNamed:@"ico_list@2x"] forState:UIControlStateNormal];
        [btnCatalogue addTarget:self action:@selector(catalogueAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:btnBack];
        [_bottomView addSubview:btnComment];
        [_bottomView addSubview:btnFavorite];
        [_bottomView addSubview:btnShare];
        [_bottomView addSubview:btnCatalogue];
        
        
        [self.view addSubview:_bottomView];
        
        
        
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/add"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/add&token=668347be401c6500aea15598fbce8fab&category=%@",_magazineModel.magazineID,@"magazine"];
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
                    NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/delete&token=668347be401c6500aea15598fbce8fab&category=%@",_magazineModel.magazineID,@"magazine"];
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
- (void)_createCollectionView {
    //布局
    UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
   // flowLayou.minimumInteritemSpacing = 15;
    flowLayou.minimumLineSpacing = 10;
    CGFloat itemSize = kScreenWidth;
    
    //需要获取图片高度
    
    flowLayou.itemSize = CGSizeMake(itemSize, kScreenHeight);
   // flowLayou.sectionInset = UIEdgeInsetsMake(10, 10, -39, 10);
    flowLayou.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    _detalilsView = [[MagazineDetailsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth+10, kScreenHeight+10) collectionViewLayout:flowLayou];
    [self.view addSubview:_detalilsView];
    
    [_detalilsView registerClass:[MagazineDetailsCell class] forCellWithReuseIdentifier:@"MagazineDetailsCell"];
    _detalilsView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    
}
- (void)_createTapGestureRecognizer {
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    oneTap.numberOfTapsRequired = 1;
    oneTap.numberOfTouchesRequired = 1;
    [_detalilsView addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapAction)];
    twoTap.numberOfTapsRequired = 2;
    twoTap.numberOfTouchesRequired = 1;
    [_detalilsView addGestureRecognizer:twoTap];
    
    [oneTap requireGestureRecognizerToFail:twoTap];
}

-(void)twoTapAction
{
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    _isHidden = !_isHidden;
    
    if (_isHidden == YES) {
        
        [UIView animateWithDuration:0.2 animations:^{
           // [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_bottomView cache:YES];
            _bottomView.transform = CGAffineTransformMakeTranslation(0, 38);
//            UIApplication *app = [UIApplication sharedApplication];
//            [app setStatusBarHidden:YES animated:UIStatusBarAnimationFade];
            
        }];

    }
    
    if (_isHidden == NO) {
        
        [UIView animateWithDuration:0.3 animations:^{
                        // [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_bottomView cache:YES];
            _bottomView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    
    
    
}




- (void)_loadURL {
    
    NSString *strURL = [NSString stringWithFormat:@"http://api.ilohas.com/magazine/%@",_magazineModel.magazineID];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
  //  [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [NSURLConnection connectionWithRequest:request delegate:self];
  
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"网络连接出错：%@",error);
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  {
    
    _receiveData = [[NSMutableData alloc] init];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    
    [_receiveData appendData:data];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableLeaves error:nil];
  
  
    [self _loadData:dic];
    
    
}

- (void)_loadData:(NSDictionary *)dictionary {
    

    NSDictionary *contentDic = dictionary[@"content"];
    MagazineDetailsModel *model = [[MagazineDetailsModel alloc] initWithDataDic:contentDic];
    
    [_modelArray addObject:model];
    
    NSArray *arr = contentDic[@"catalog"];
    _tableViewArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        [_tableViewArr addObject:dic];
    }
    CatalogueTableView *_tableView = [[CatalogueTableView alloc] init];
    _tableView.catalogueArray = _tableViewArr;
    

    
    
    NSDictionary *imgDic = contentDic[@"image"];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < imgDic.count; i++) {
        NSString *imageURL = [imgDic objectForKey:[NSString stringWithFormat:@"%i",i+1]];
        [imgArr addObject:imageURL];
    }
    
    _detalilsView.magazineArr = imgArr;
    
  //  NSLog(@"+++++++%@",_detalilsView.magazineArr);
    
    
    [_detalilsView reloadData];
    
}

//按钮方法

- (void)backAction {
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)commentAction
{
    MyhomeViewController *home = [[MyhomeViewController alloc] init];
    
    home.urlStr = @"http://api.ilohas.com/comment/list";
    home.bodyStr = [NSString stringWithFormat:@"article_id=%@&url=http://api.ilohas.com/comment/list&category=%@&pagesize=10",_magazineModel.magazineID,@"magazine"];
    home.type = @"magazine";
    home.title = @"评论";
    home.articleID = _magazineModel.magazineID;
    home.isUnnormal = YES;
    NSLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:home animated:YES];
    
}

- (void)favoriteAction:(UIButton *)btn {
    if (!btn.selected) {
        NSURL *url = [NSURL URLWithString:@"http://api.ilohas.com/favorite/add"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/add&token=668347be401c6500aea15598fbce8fab&category=%@",_magazineModel.magazineID,@"magazine"];
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
        NSString *bodyText = [NSString stringWithFormat:@"item_id=%@&url=http://api.ilohas.com/favorite/delete&token=668347be401c6500aea15598fbce8fab&category=%@",_magazineModel.magazineID,@"magazine"];
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

- (void)shareAction {
    
    NSLog(@"分享");
    if (_shareview != nil){
        _shareview = nil;
    }
    
    _shareview = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _shareview.type = @"magezine";
    _shareview.itemId = _magazineModel.magazineID;
    [self.view addSubview:_shareview];
    
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [myDelegate.window.rootViewController.view addSubview:_shareview];
    
    
}

- (void)catalogueAction {
    
    NSLog(@"目录");
    CatalogueViewController *viewCon = [[CatalogueViewController alloc] init];
    BaseNavController *baseNav = [[BaseNavController alloc] initWithRootViewController:viewCon];
    
    [self presentViewController:baseNav animated:YES completion:nil];
    
    viewCon.tableView.catalogueArray = _tableViewArr;
}


-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
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
