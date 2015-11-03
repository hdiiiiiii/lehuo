//
//  MagazineDetailsModel.h
//  Project4
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseModel.h"

@interface MagazineDetailsModel : BaseModel

@property (nonatomic, copy) NSString *detailsID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *pub_date;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) NSString *favorites;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *image_link;
@property (nonatomic, copy) NSString *catalog;

@end
