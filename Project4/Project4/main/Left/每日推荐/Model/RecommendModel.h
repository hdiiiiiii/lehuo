//
//  RecommendModel.h
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

/*
"id": "667",
"title": "台湾好野菜，节气田边食”,//标题
"cover": "http://img.ilohas.com",
"cover_small": "http://img.ilohas.com/upload/1510/18/18769739305623009971cd77.63591503.jpg",//封面小图
"app_cover": "http://img.ilohas.com/upload/1510/18/66658022856230099776197.17945753.jpg",//大图
"image": "http://img.ilohas.com/upload/1510/18/725161531562300995b31f5.78742529.jpg",
"seo_keywords": "野菜,二十四节气,,种籽设计",//关键字
"seo_description": "",
"content": "",//内容
"likes": "3",//推测为点赞
"favorites": "3",//推测为收藏
"hits": "759",//推测为点击量
"replies": "0",
"dateline": "1445184000"//时间戳 为封面时间
*/

#import "BaseModel.h"

@interface RecommendModel : BaseModel

@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *cover_small;
@property (nonatomic,copy) NSString *app_cover;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *seo_keywords;
@property (nonatomic,copy) NSString *seo_description;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *likes;
@property (nonatomic,copy) NSString *favorites;
@property (nonatomic,copy) NSString *hits;
@property (nonatomic,copy) NSString *replies;
@property (nonatomic,copy) NSString *dateline;








@end
