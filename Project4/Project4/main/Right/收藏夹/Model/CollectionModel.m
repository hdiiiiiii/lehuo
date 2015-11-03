//
//  CollectionModel.m
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel
-(NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"cover":@"cover",
                             @"collectionID":@"id",
                             @"item_id":@"item_id",
                             @"title":@"title"
                             };
    return mapAtt;
}

@end
