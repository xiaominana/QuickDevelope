//
//  UIImage+CircleImage.h
//  qxt
//
//  Created by 赵文龙 on 16/8/15.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleImage)

/**
 *  设置圆形图片
 *
 *  @return 返回圆形图片
 */
- (UIImage *)cutCircleImage;

/**
 根据颜色创建图片

 @param color 颜色
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
