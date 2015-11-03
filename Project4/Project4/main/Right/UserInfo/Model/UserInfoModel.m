//
//  UserInfoModel.m
//  UserInfo
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(NSDictionary *)attributeMapDictionary
{

    NSDictionary *mapAtt = @{@"noteID":@"id",
                             @"uid":@"uid",
                             @"feed_type":@"feed_type",
                             @"item_id":@"item_id",
                             @"content":@"content",
                             @"likes":@"likes",
                             @"replies":@"replies",
                             @"dateline":@"dateline",
                             @"username":@"username",
                             @"avatar":@"avatar"
                             };
    return mapAtt;
}

@end
