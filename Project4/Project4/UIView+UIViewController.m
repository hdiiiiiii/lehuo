//
//  UIView+UIViewController.m
//  Project4
//
//  Created by apple on 15/10/17.
//  Copyright (c) 2015年 LL. All rights reserved.

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)
- (UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}
@end
