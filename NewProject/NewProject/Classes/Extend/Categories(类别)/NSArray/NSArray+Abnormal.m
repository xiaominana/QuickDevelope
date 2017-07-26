//
//  NSArray+Abnormal.m
//  PodDemo
//
//  Created by 赵文龙 on 16/2/3.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import "NSArray+Abnormal.h"

@implementation NSArray (Abnormal)

+(void)load
{
    [super load];
    Method m1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method m2 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(my_objectAtIndex:));
    method_exchangeImplementations(m1, m2);
}

-(id)my_objectAtIndex:(NSInteger)index
{
    if (self.count<=index)
    {
        @try {
            return [self my_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            DebugLog(@"%@",self);

            if (isDev)
            {
                [RootViewController crashAlert:[self class]];
            }
            
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {
            
        }
                return nil;
    }
    else
    {
        return [self my_objectAtIndex:index];
    }
}

@end
