//
//  UILabel+Attributed.h
//  PodDemo
//
//  Created by 赵文龙 on 16/2/3.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Attributed)

/**
 *  是否添加删除线
 *
 *  @param Strikeout default is NO
 */
-(void)setStrikeout:(BOOL)Strikeout;

/**
 *  给文本添加下划线
 *
 *  @param style 下划线宽度
 *  @param range 添加下划线的位置
 */
-(void)setAttributedUnderline:(NSNumber *)style range:(NSRange)range;


/**
 *  添加文本字体
 *
 *  @param font  文本字体
 *  @param range 添加文本字体的位置
 */
-(void)setAttributedTextFont:(UIFont *)font range:(NSRange)range;

/**
 *  添加文本颜色
 *
 *  @param color 颜色
 *  @param range 添加文本颜色的位置
 */
-(void)setAttributedTextColor:(UIColor *)color range:(NSRange)range;

@end
