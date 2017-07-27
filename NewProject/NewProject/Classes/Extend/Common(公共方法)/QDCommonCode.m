//
//  QDCommonCode.m
//  NewProject
//
//  Created by 中盛锦华 on 2017/7/27.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import "QDCommonCode.h"

@implementation QDCommonCode

UILabel * label;

#pragma mark - 1 UILabel
#pragma mark - 设置UILabel行间距
-(void)funcUILabelLineSpace
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:label.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:20];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, label.text.length)];
    label.attributedText = attrString;
    // 或者使用xib
}

#pragma mark - UILabel显示不同颜色字体
-(void)funcUILabelDifferentColor
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:label.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5,6)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(11,5)];
    label.attributedText = string;
}






@end
