//
//  CollectionModel.h
//  Project4
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "BaseModel.h"
/*
 {
 cover = "/upload/1509/11/174905968355f28f7e60ee05.50244328.jpg";
 id = 9448;
 "item_id" = 62;
 title = "\U5bd2\U9732\U53f7";
 }
 */
@interface CollectionModel : BaseModel
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *collectionID;
@property (nonatomic,copy)NSString *item_id;
@property (nonatomic,copy)NSString *title;

@end
