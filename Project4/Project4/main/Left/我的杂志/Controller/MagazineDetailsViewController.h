//
//  MagazineDetailsViewController.h
//  Project4
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineDetailsModel.h"
#import "MagazineModel.h"

@interface MagazineDetailsViewController : UIViewController
@property (nonatomic,strong)MagazineDetailsModel *model;
@property (nonatomic,strong)MagazineModel *magazineModel;

@end
