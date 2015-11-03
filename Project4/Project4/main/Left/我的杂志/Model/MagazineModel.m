//
//  MagazineModel.m
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineModel.h"

@implementation MagazineModel

-(NSDictionary *)attributeMapDictionary
{
    /*
     @property (nonatomic,copy)NSString *magazineID;
     @property (nonatomic,copy)NSString *title;
     @property (nonatomic,copy)NSString *cover;
     @property (nonatomic,copy)NSString *pub_date;
     @property (nonatomic,copy)NSString *platform;
     @property (nonatomic,copy)NSString *likes;
     @property (nonatomic,copy)NSString *favorites;
     @property (nonatomic,copy)NSString *replies;
     @property (nonatomic,copy)NSString *dateline;
     */
    NSDictionary *mapAtt =  @{
                              @"magazineID":@"id",
                              @"title":@"title",
                              @"cover":@"cover",
                              @"pub_date":@"pub_date",
                              @"platform":@"platform",
                              @"likes":@"likes  ",
                              @"favorites":@"favorites",
                              @"replies":@"replies",
                              @"dateline":@"dateline",
                              };
    return mapAtt;
}

@end
