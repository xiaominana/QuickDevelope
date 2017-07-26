//
//  NSObject+Empty.m
//  qxt
//
//  Created by 赵文龙 on 2016/10/26.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import "NSObject+Empty.h"

@implementation NSObject (Empty)

/**
 判断该对象是否是空
 
 @param str 需要返回的字符串
 
 @return 返回的字符串
 */
-(NSString *)isEmptyString:(NSString *)str
{
    if (!self)
    {
        if (str)
        {
            return str;
        }
        else
        {
            return @"";
        }
    }
    return [[NSString alloc] initWithFormat:@"%@",self];
}


/**
 判断该对象是否是空
 
 @return 返回空数组
 */
-(NSArray *)isEmptyArray
{
    if (!self)
    {
        return @[];
    }
    return (NSArray *)self;
}


/**
 判断该对象是否是空
 
 @return 返回空字典
 */
-(NSDictionary *)isEmptyDictionary
{
    if (!self)
    {
        return @{};
    }
    return (NSDictionary *)self;
}

@end
