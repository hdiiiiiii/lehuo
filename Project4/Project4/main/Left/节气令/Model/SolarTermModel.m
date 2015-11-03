//
//  SolarTermModel.m
//  Project4
//
//  Created by apple on 15/10/23.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "SolarTermModel.h"
/*@property(nonatomic,copy)NSString *idStr;
 @property(nonatomic,copy)NSString *title;
 @property(nonatomic,copy)NSString *cover;
 @property(nonatomic,copy)NSString *cover_small;
 @property(nonatomic,copy)NSString *app_cover;
 @property(nonatomic,copy)NSString *content;
 @property(nonatomic,copy)NSString *likes;
 @property(nonatomic,copy)NSString *favorites;
 @property(nonatomic,copy)NSString *hits;
 @property(nonatomic,copy)NSString *replies;
 @property(nonatomic,copy)NSString *dateline;
 */

@implementation SolarTermModel
-(NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{@"idStr":@"id",
                             @"title":@"title",
                             @"cover":@"cover",
                             @"cover_small":@"cover_small",
                             @"app_cover":@"app_cover",
                             @"content":@"content",
                             @"image":@"image",
                             @"likes":@"likes",
                             @"favorites":@"favorites",
                             @"hits":@"hits",
                             @"replies":@"replies",
                             @"dateline":@"dateline",
                             
                             
                             };
    return mapAtt;
}
@end
