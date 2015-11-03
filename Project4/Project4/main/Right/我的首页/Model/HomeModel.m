//
//  HomeModel.m
//  我的首页
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

//@property (nonatomic,copy)NSString *homeID;
//@property (nonatomic,copy)NSString *uid;
//@property (nonatomic,copy)NSString *feed_type;
//@property (nonatomic,copy)NSString *content;
//@property (nonatomic,copy)NSString *likes;
//@property (nonatomic,copy)NSString *replies;
//@property (nonatomic,copy)NSString *dateline;
//@property (nonatomic,copy)NSString *username;
//@property (nonatomic,copy)NSString *avatar;

-(NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{@"homeID":@"id",
                             @"uid":@"uid",
                             @"feed_type":@"feed_type",
                             @"content":@"content",
                             @"likes":@"likes",
                             @"replies":@"replies",
                             @"dateline":@"dateline",
                             @"username":@"username",
                             @"avatar":@"avatar",
                             };
    return mapAtt;
}
@end
