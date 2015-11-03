//
//  FollowerModel.h
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseModel.h"
/*
 "uid": "18",
 "username": "小耳朵",
 "avatar": "http://www.ilohas.com/upload/avatar/1411/10/9792244605460211960bb22.43341542.gif",
 "note_total": "4",
 "follow_status": 1
 */
@interface FollowerModel : BaseModel
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *note_total;
@property (nonatomic,copy)NSNumber *follow_status;
@end
