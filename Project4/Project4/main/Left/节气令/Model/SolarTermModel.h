//
//  SolarTermModel.h
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//
/*
 "id": "62",
 "title": "寒露号",
 "cover": "http://img.ilohas.com/upload/1509/11/16528609855f28f7e3044c8.93844440.jpg",
 "cover_small": "http://img.ilohas.com/upload/1509/11/33283954555f29052e8a9c1.66685179.jpg",
 "app_cover": "http://img.ilohas.com/upload/1509/11/174905968355f28f7e60ee05.50244328.jpg",
 "image": "http://img.ilohas.com/upload/1509/11/206781388155f29052d2a308.98282446.jpg",
 "seo_keywords": "",
 "seo_description": "",
 "content": "",
 "likes": "51",
 "favorites": "3",
 "hits": "4170",
 "replies": "0",
 "dateline": "1444233600"
 */


#import "BaseModel.h"
@interface SolarTermModel : BaseModel
@property(nonatomic,copy)NSString *idStr;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *cover_small;
@property(nonatomic,copy)NSString *app_cover;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *likes;
@property(nonatomic,copy)NSString *favorites;
@property(nonatomic,copy)NSString *hits;
@property(nonatomic,copy)NSString *replies;
@property(nonatomic,copy)NSString *dateline;

@end
