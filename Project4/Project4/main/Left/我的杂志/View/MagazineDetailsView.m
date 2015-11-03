//
//  MagazineDetailsView.m
//  Project4
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineDetailsView.h"
#import "MagazineModel.h"
#import "MagazineDetailsCell.h"
#import "MagazineDetailsModel.h"
@interface MagazineDetailsView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
}

@end

@implementation MagazineDetailsView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout  {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:231.0f/255.0f alpha:1];
        
        self.pagingEnabled = YES;
        
        
    }
    return self;
}
#pragma mark -datasource代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

  
    
    
    return _magazineArr.count;
   
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MagazineDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MagazineDetailsCell" forIndexPath:indexPath];
 //  MagazineDetailsModel *detailsModel = [[MagazineDetailsModel alloc] init];

        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_magazineArr[indexPath.row] ] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //图片下载完成调用的block
            CGFloat a  ;
            
            if (image.size.width == 0) {
                a = kScreenWidth;
            }
            else{
                a = kScreenWidth/image.size.width;
            }
            cell.imageView.frame = CGRectMake(0, 0, kScreenWidth, image.size.height*a);
            cell.scrollerView.contentSize = CGSizeMake(kScreenWidth, image.size.height*a);
            NSLog(@"%f",cell.scrollerView.contentSize.height) ;
            
        }];
    
    
    
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    MagazineDetailsCell *detail = (MagazineDetailsCell *)cell;
    [detail backImageZoomingScale];
    
}


//#pragma mark - flowlayout代理方法
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//   // CGFloat itemSize = (kScreenWidth - 50)/3;
//  //  CGFloat height = itemSize*1.43+20+40;
//    return CGSizeMake(kScreenWidth, kScreenHeight );
//}





@end
