//
//  UserTopModel.h
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseModel.h"
/*
 {
	"status": 0,
	"content": {
 "uid": "5281",
 "app_openid": "",
 "username": "736410133",
 "gender": "1",
 "email": "736410133@qq.com",
 "avatar": "http:\/\/www.ilohas.com\/templates\/default\/images\/noavatar.jpg",
 "follows": "4",
 "fans": "0",
 "note_total": "2"
	}
 }
 */
@interface UserTopModel : BaseModel
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *app_openid;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *gender;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *follows;
@property (nonatomic,copy)NSString *fans;
@property (nonatomic,copy)NSString *note_total;

@end
