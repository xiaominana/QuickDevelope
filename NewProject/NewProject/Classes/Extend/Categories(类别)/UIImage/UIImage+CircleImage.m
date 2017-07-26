//
//  UIImage+CircleImage.m
//  qxt
//
//  Created by 赵文龙 on 16/8/15.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)

/**
 *  设置圆形图片
 *
 *  @return 返回圆形图片
 */
- (UIImage *)cutCircleImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    // 设置圆形
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctr, rect);
    // 裁剪
    CGContextClip(ctr);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 根据颜色创建图片
 
 @param color 颜色
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
