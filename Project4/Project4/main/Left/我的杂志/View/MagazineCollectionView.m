//
//  MagazineCollectionView.m
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineCollectionView.h"
#import "MagazineCell.h"
#import "MBProgressHUD.h"
#import "MagazineDetailsViewController.h"
#import "UIView+UIViewController.h"
@interface MagazineCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_imageArray;
    MBProgressHUD *_hud;
    BOOL _isDownload;
    
}
@end

@implementation MagazineCollectionView


-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        //self.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
    }
    return self;
}


#pragma mark -datasource代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MagazineCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"MagazineCell" forIndexPath:indexPath];
    
    MagazineModel *model = self.modelArray[indexPath.row];
    cell.model = model;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ==  %@",model.magazineID];
    
    NSArray *filterdArray = [_magazineIDArray filteredArrayUsingPredicate:predicate ];
    
    if (filterdArray.count != 0) {
        cell.downloadBtn.hidden = YES;
    }
    if (filterdArray.count == 0) {
        cell.downloadBtn.hidden = NO;
        [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"btn_download@2x"] forState:UIControlStateNormal];
    }
    cell.downloadBtn.tag = indexPath.row;
    [cell.downloadBtn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击");
    MagazineDetailsViewController *view = [[MagazineDetailsViewController alloc] init];
    UINavigationController *nacV = [[UINavigationController alloc] initWithRootViewController:view];
    view.magazineModel = self.modelArray[indexPath.row];
    [self.viewController presentViewController:nacV animated:YES completion:nil];
    
}

#pragma mark - flowlayout代理方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemSize = (kScreenWidth - 50)/3;
    CGFloat height = itemSize*1.43+20+40;
    return CGSizeMake(itemSize, height);
}
#pragma mark -按钮方法
-(void)download:(UIButton *)sender
{
    
    if (!_isDownload) {
        [sender setBackgroundImage:nil forState:UIControlStateNormal];
        _isDownload = YES;
        _hud = [MBProgressHUD showHUDAddedTo:sender animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.opacity = 0;
        _hud.progress = 0.0;
        
        MagazineModel *model = self.modelArray[sender.tag];
        NSString *urlStr = [NSString stringWithFormat:@"http://api.ilohas.com/magazine/%@",model.magazineID];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                NSLog(@"请求失败");
            }
            _imageArray = [NSMutableArray array];
            NSData *resData = [[NSData alloc] initWithData:data];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *dataDic = dic[@"content"];
            NSDictionary *imageDic = dataDic[@"image"];
            
            for (NSString *str in imageDic) {
                NSString *imageURL = imageDic[str];
                [_imageArray addObject:imageURL];
                
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                __block float i = 0;
                for (NSString *str in _imageArray) {
                    
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        i = i+1;
                        
                        _hud.progress = i/(_imageArray.count/1.0);
                        if (i == _imageArray.count) {
                            _hud.hidden = YES;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self btnHide:sender];
                            });
                            NSLog(@"sdadas");
                            _isDownload = NO;
                            NSMutableArray *idArr = [[NSUserDefaults standardUserDefaults] objectForKey:kMagazineID];
                            if (idArr.count == 0) {
                                NSMutableArray *idArray = [[NSMutableArray alloc] init];
                                [[NSUserDefaults standardUserDefaults] setObject:idArray forKey:kMagazineID];
                                [idArray addObject:model.magazineID];
                                [[NSUserDefaults standardUserDefaults] setObject:idArray forKey:kMagazineID];
                            }
                            else{
                                idArr = [[NSMutableArray alloc] initWithArray:idArr];
                                [idArr addObject:model.magazineID];
                                [[NSUserDefaults standardUserDefaults] setObject:idArr forKey:kMagazineID];
                            }
                        }
                        
                    }];
                }
            });
            
            
        }];
    }
    
}

-(void)btnHide:(UIButton *)btn
{
    btn.hidden = YES;
}

-(void)_download:(NSArray *)imageArray withMagaZineID:(NSString *)magazineID withBtn:(UIButton *)btn
{
    __block float i = 0;
    for (NSString *str in imageArray) {
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //NSLog(@"进度: %li",receivedSize/expectedSize);
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            NSLog(@"完成");
            i = i+1;
            
            _hud.progress = i/(imageArray.count/1.0);
            if (i == imageArray.count) {
                [_hud hide:YES];
                _isDownload = NO;
                NSMutableArray *idArr = [[NSUserDefaults standardUserDefaults] objectForKey:kMagazineID];
                if (idArr.count == 0) {
                    NSMutableArray *idArray = [[NSMutableArray alloc] init];
                    [[NSUserDefaults standardUserDefaults] setObject:idArray forKey:kMagazineID];
                    [idArray addObject:magazineID];
                    [[NSUserDefaults standardUserDefaults] setObject:idArray forKey:kMagazineID];
                }
                else{
                    idArr = [[NSMutableArray alloc] initWithArray:idArr];
                    [idArr addObject:magazineID];
                    [[NSUserDefaults standardUserDefaults] setObject:idArr forKey:kMagazineID];
                    NSLog(@"%@",idArr);
                }
            }
            
        }];
    }
}

/*
 NSString *homePath=NSHomeDirectory();
 NSLog(@"%@",homePath);
 
 
 NSArray *arr=@[@"/library/Caches/ll.Project4/fsCachedData/",
 @"/library/Caches/default/com.hackemist.SDWebImageCache.default/"];
 
 for (NSString *str in arr) {
 NSString *filePath=[NSString stringWithFormat:@"%@%@",homePath,str];
 NSFileManager *manager=[NSFileManager defaultManager];
 NSArray *fileNames=[manager subpathsOfDirectoryAtPath:filePath error:nil];
 for (NSString *fileName in fileNames) {
 NSString *subFilePath=[NSString stringWithFormat:@"%@%@",filePath,fileName];
 [manager removeItemAtPath:subFilePath error:nil];
 }
 
 }
 
 NSMutableArray *IDarray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kMagazineID]];
 [IDarray removeAllObjects];
 [[NSUserDefaults standardUserDefaults] setObject:IDarray forKey:kMagazineID];
 */


@end
