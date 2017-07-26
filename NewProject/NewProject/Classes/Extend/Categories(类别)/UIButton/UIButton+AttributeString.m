//
//  UIButton+AttributeString.m
//  qxt
//
//  Created by 王艳茹 on 16/6/1.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import "UIButton+AttributeString.h"

@implementation UIButton (AttributeString)
-(void)setAttributedTextFont:(UIFont *)font range:(NSRange)range
{
   
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLabel.attributedText];
    
    [attributeString addAttributes:@{NSFontAttributeName : font} range:range];
    [self setAttributedTitle:attributeString forState:UIControlStateNormal];

}

-(void)setAttributedTextColor:(UIColor *)color range:(NSRange)range
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLabel.attributedText];
   [attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [self setAttributedTitle:attributeString forState:UIControlStateNormal];
}
@end
