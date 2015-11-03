//
//  MagazineDetailsModel.m
//  Project4
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "MagazineDetailsModel.h"

@implementation MagazineDetailsModel




- (NSDictionary *)attributeMapDictionary {
    
    NSDictionary *mapAtt = @{
                             @"detailsID":@"id",
                             @"title":@"title",
                             @"cover":@"cover",
                             @"pub_date":@"pub_date",
                             @"platform":@"platform",
                             @"likes":@"likes",
                             @"favorites":@"favorites",
                             @"replies":@"replies",
                             @"dateline":@"dateline",
                             @"image":@"image",
                             @"image_link":@"image_link",
                             @"catalog":@"catalog"
                             };
    
    return mapAtt;
    
}

@end
