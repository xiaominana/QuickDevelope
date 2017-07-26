//
//  UIView+Asynchronously.m
//  PodDemo
//
//  Created by zwl on 16/1/18.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import "UIView+Asynchronously.h"

@implementation UIView (Asynchronously)


/**
 *  设置一个视图的渐变色
 *
 *  @param colors     渐变颜色数组
 *  @param points     渐变颜色的位置
 *  @param startPoint 开始位置
 *  @param endPoint   结束位置
 */
-(void)setGradientColor:(NSArray<UIColor *> *)colors point:(NSArray<NSNumber *> *)points startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    NSMutableArray *CGColors = [[NSMutableArray alloc] init];
    for (UIColor *color in colors)
    {
        [CGColors addObject:(id)color.CGColor];
    }
    
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.startPoint = startPoint;
    headerLayer.endPoint = endPoint;
    headerLayer.colors = CGColors;
    headerLayer.locations = points;
    headerLayer.frame = self.bounds;
    
    [self.layer insertSublayer:headerLayer atIndex:0];
}

/**
 *  设置视图的阴影
 *
 *  @param opacity      阴影的透明度
 *  @param shadowColor  阴影的颜色
 *  @param shadowOffset 阴影的范围，与坐标系一致
 *  @param shadowRadius 阴影的虚化程度
 */
-(void)setShadowOpacity:(float)shadowOpacity shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(float)shadowRadius
{
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowColor = shadowColor.CGColor;
}

//+(void)load
//{
//    [super load];
//    Method m1 = class_getInstanceMethod(objc_getClass("UIView"), @selector(initWithFrame:));
//    Method m2 = class_getInstanceMethod(objc_getClass("UIView"), @selector(my_initWithFrame:));
//    method_exchangeImplementations(m1, m2);
//}

-(id)my_initWithFrame:(CGRect)frame
{
    self.layer.drawsAsynchronously = YES;
    return [self my_initWithFrame:frame];
}

-(instancetype)rootWithFrame:(CGRect)frame asynchronously:(BOOL)asynchronously
{

    self.layer.drawsAsynchronously = YES;
    return [self initWithFrame:frame];
}

-(void)setBrokenLine
{

   CAShapeLayer * border = [CAShapeLayer layer];
    
    border.strokeColor = self.layer.borderColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    
    border.lineWidth = 1;
    
    border.lineCap = @"round";
    
    border.lineDashPattern = @[@3, @3];
    
    [self.layer addSublayer:border];

}

@end
