//
//  UIButton+AttributeString.h
//  qxt
//
//  Created by 王艳茹 on 16/6/1.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AttributeString)
-(void)setAttributedTextFont:(UIFont *)font range:(NSRange)range;


-(void)setAttributedTextColor:(UIColor *)color range:(NSRange)range;
@end
