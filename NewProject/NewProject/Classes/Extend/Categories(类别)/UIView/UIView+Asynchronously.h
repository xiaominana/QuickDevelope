//
//  UIView+Asynchronously.h
//  PodDemo
//
//  Created by zwl on 16/1/18.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (Asynchronously)

/**
 *  设置视图的阴影
 *
 *  @param opacity      阴影的透明度
 *  @param shadowColor  阴影的颜色
 *  @param shadowOffset 阴影的范围，与坐标系一致
 *  @param shadowRadius 阴影的虚化程度
 */
-(void)setShadowOpacity:(float)opacity shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius;

/**
 *  设置一个视图的渐变色
 *
 *  @param colors     渐变颜色数组
 *  @param points     渐变颜色的位置
 *  @param startPoint 开始位置
 *  @param endPoint   结束位置
 */
-(void)setGradientColor:(NSArray<UIColor *> *)colors point:(NSArray<NSNumber *> *)points startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

-(instancetype)rootWithFrame:(CGRect)frame asynchronously:(BOOL)asynchronously;

-(void)setBrokenLine;

@end
