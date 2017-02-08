//
//  NSArray+extention.m
//  LiquidLoader
//
//  Created by fernando on 2017/2/7.
//  Copyright © 2017年 fernando. All rights reserved.
//

#import "NSArray+extention.h"

@implementation NSArray (extention)

- (NSArray *)getValuesWithCount:(NSInteger)count {
    if (self.count <= 0) {
        return @[];
    }
    
    count = self.count < count ? self.count : count;
    NSArray *array = [NSArray array];
    
    for (int i = 0; i < count; i ++) {
        [array arrayByAddingObject:self[i]];
    }
    
    return array;
}

@end
