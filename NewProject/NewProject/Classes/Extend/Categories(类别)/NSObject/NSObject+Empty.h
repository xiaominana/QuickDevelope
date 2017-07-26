//
//  NSObject+Empty.h
//  qxt
//
//  Created by 赵文龙 on 2016/10/26.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Empty)


/**
 判断该对象是否是空

 @param str 需要返回的字符串

 @return 返回的字符串
 */
-(NSString *)isEmptyString:(NSString *)str;


/**
 判断该对象是否是空

 @return 返回空数组
 */
-(NSArray *)isEmptyArray;


/**
 判断该对象是否是空

 @return 返回空字典
 */
-(NSDictionary *)isEmptyDictionary;

@end
