//
//  HomeModel.h
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseModel.h"

/*
 "id": "3208",
 "uid": "5281",
 "feed_type": "note",
 "content": "{\"content\":\"\\u8fd9\\u662f\\u4ec0\\u4e48\\u5462\\uff1f\"}",
 "likes": "0",
 "replies": "0",
 "dateline": "1445771658",
 "username": "736410133",
 "avatar": "http://img.ilohas.com/templates/default/images/noavatar.jpg"
 */


@interface HomeModel : BaseModel
@property (nonatomic,copy)NSString *homeID;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *feed_type;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *likes;
@property (nonatomic,copy)NSString *replies;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *avatar;
@end
