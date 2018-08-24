//
//  DynamicItem.m
//  DynamicScrollView
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DynamicItem.h"

@implementation DynamicItem

@synthesize bounds;

@synthesize center;

@synthesize transform;

- (instancetype)init {
    if (self = [super init]) {
        bounds = CGRectMake(0, 0, 1, 1);
    }
    return self;
}
@end
