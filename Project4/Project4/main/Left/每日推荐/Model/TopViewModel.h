//
//  TopViewModel.h
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

//"id": "51",
//"type": "magazine",
//"title": "《发现阿姆斯特丹》",
//"image": "http://img.ilohas.com/upload/1510/14/1973155909561dc47c885526.09080303.jpg",
//"main_image": "",
//"content": "",
//"url": "118”,网址需要拼接  将118拼上去即可  http://api.ilohas.com/magazine/118（只适用于这一条）
//"ord": "1",
//"platform": "1"

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface TopViewModel : BaseModel


@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *main_image;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *ord;
@property (nonatomic,copy) NSString *platform;


@end
