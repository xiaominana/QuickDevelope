//
//  UILabel+Attributed.m
//  PodDemo
//
//  Created by 赵文龙 on 16/2/3.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import "UILabel+Attributed.h"

@implementation UILabel (Attributed)


/**
 *  是否添加删除线
 *
 *  @param Strikeout default is NO
 */
-(void)setStrikeout:(BOOL)Strikeout
{
    //    _Strikeout = Strikeout;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSStrikethroughStyleAttributeName value:@1.0 range:NSMakeRange(0, str.length)];
    self.attributedText = str;
}


/**
 *  给文本添加下划线
 *
 *  @param style 下划线宽度
 *  @param range 添加下划线的位置
 */
-(void)setAttributedTextFont:(UIFont *)font range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [str addAttribute:NSFontAttributeName value:font range:range];
    self.attributedText = str;
}


/**
 *  添加文本字体
 *
 *  @param font  文本字体
 *  @param range 添加文本字体的位置
 */
-(void)setAttributedTextColor:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = str;
}


/**
 *  添加文本颜色
 *
 *  @param color 颜色
 *  @param range 添加文本颜色的位置
 */
-(void)setAttributedUnderline:(NSNumber *)style range:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [str addAttribute:NSUnderlineStyleAttributeName value:style range:range];
    self.attributedText = str;
}

@end
