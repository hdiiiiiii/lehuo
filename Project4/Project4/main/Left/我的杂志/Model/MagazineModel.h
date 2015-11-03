//
//  MagazineModel.h
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseModel.h"
/*
 "id": "119",
 "title": "INOHERB 别册",//标题
 "cover": "http://img.ilohas.com/upload/1510/17/212196742956226a6c560891.21808742.jpg”,//封面图片
 "pub_date": "2015.10.17－2015.11.07",//时间
 "platform": "1",
 "likes": "0",
 "favorites": "3",
 "replies": "0",
 "dateline": "1445011200"
 */
@interface MagazineModel : BaseModel
@property (nonatomic,copy)NSString *magazineID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *pub_date;
@property (nonatomic,copy)NSString *platform;
@property (nonatomic,copy)NSString *likes;
@property (nonatomic,copy)NSString *favorites;
@property (nonatomic,copy)NSString *replies;
@property (nonatomic,copy)NSString *dateline;

@end
