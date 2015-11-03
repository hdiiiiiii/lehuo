//
//  TopViewModel.m
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "TopViewModel.h"

@implementation TopViewModel

- (NSDictionary *)attributeMapDictionary {
    
    
    NSDictionary *mapAtt = @{
                             @"idStr":@"id",
                             @"type":@"type",
                             @"title":@"title",
                             @"image":@"image",
                             @"main_image":@"main_image",
                             @"content":@"content",
                             @"url":@"url",
                             @"ord":@"ord",
                             @"platform":@"platform"

                             
                             };
    
    
    return mapAtt;
}


@end
