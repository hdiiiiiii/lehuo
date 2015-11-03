//
//  UIScrollView+Touch.m
//  Project4
//
//  Created by apple on 15/10/24.
//  Copyright (c) 2015年 LL. All rights reserved.
//

#import "UIScrollView+Touch.h"

@implementation UIScrollView (Touch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    //[super touchesBegan:touches withEvent:event];
}


@end
