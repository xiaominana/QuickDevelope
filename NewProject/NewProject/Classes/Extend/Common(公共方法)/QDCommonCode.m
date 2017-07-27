//
//  QDCommonCode.m
//  NewProject
//
//  Created by 中盛锦华 on 2017/7/27.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import "QDCommonCode.h"

@implementation QDCommonCode

#pragma mark - UIView

UIView * view;

#pragma mark - 将一个view保存为pdf格式
- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}

#pragma mark - 让一个view在父视图中心
-(void)funcMakeChildViewInParentCenter
{
    UIView * parentView = view.superview;
    view.center = [parentView convertPoint:parentView.center fromView:parentView.superview];
}

#pragma mark - copy一个view
-(UIView *)funcCopyView:(UIView *)originalView
{
    //因为UIView没有实现copy协议，因此找不到copyWithZone方法，使用copy的时候导致崩溃
    //但是我们可以通过归档再解档实现copy，这相当于对视图进行了一次深拷贝，代码如下
    id copyOfView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:originalView]];
    return copyOfView;
}

#pragma mark - 为UIView的某个方向添加边框
/**
 边框方向
 
 - WZBBorderDirectionTop: 顶部
 - WZBBorderDirectionLeft: 左边
 - WZBBorderDirectionBottom: 底部
 - WZBBorderDirectionRight: 右边
 */

typedef NS_ENUM(NSInteger, WZBBorderDirectionType) {
    WZBBorderDirectionTop = 0,
    WZBBorderDirectionLeft,
    WZBBorderDirectionBottom,
    WZBBorderDirectionRight
};

/**
 为UIView的某个方向添加边框
 
 @param direction 边框方向
 @param color 边框颜色
 @param width 边框宽度
 */

- (void)wzb_addBorder:(WZBBorderDirectionType)direction color:(UIColor *)color width:(CGFloat)width forView:(UIView *)view
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    switch (direction) {
        case WZBBorderDirectionTop:
        {
            border.frame = CGRectMake(0.0f, 0.0f, view.bounds.size.width, width);
        }
            break;
        case WZBBorderDirectionLeft:
        {
            border.frame = CGRectMake(0.0f, 0.0f, width, view.bounds.size.height);
        }
            break;
        case WZBBorderDirectionBottom:
        {
            border.frame = CGRectMake(0.0f, view.bounds.size.height - width, view.bounds.size.width, width);
        }
            break;
        case WZBBorderDirectionRight:
        {
            border.frame = CGRectMake(view.bounds.size.width - width, 0, width, view.bounds.size.height);
        }
            break;
        default:
            break;
    }
    [view.layer addSublayer:border];
}

#pragma mark - 约束如何做UIView动画？
/*
1、把需要改的约束Constraint拖条线出来，成为属性
2、在需要动画的地方加入代码，改变此属性的constant属性
3、开始做UIView动画，动画里边调用layoutIfNeeded方法
*/
/*
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;
self.buttonTopConstraint.constant = 100;
[UIView animateWithDuration:.5 animations:^{
    [self.view layoutIfNeeded];
}];
 */

#pragma mark - UIView背景颜色渐变
-(void)funcViewBackground
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - 停止UIView动画
-(void)funcViewStopAllAnimation
{
    [view.layer removeAllAnimations];
}

#pragma mark - 为UIView某个角添加圆角
-(void)funcViewAddCorner
{
    //左上角和右下角添加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - 获取一个view所属的控制器
//方法1
- (UIViewController *)belongViewControllerForView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
//方法2
- (UIViewController *)parentControllerForView:(UIView *)view
{
    UIResponder *responder = [view nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - 移除一个 view 全部子视图
-(void)removeAllSubviewsByView:(UIView *)view
{
    while (view.subviews.count)
    {
        UIView * child = view.subviews.lastObject;
        [child removeFromSuperview];
    }
}


#pragma mark - UILabel

UILabel * label;

#pragma mark - UILabel常用属性
+(UILabel *)createLabelWithFrame:(CGRect)frame Text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.numberOfLines = 0;
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    [label sizeToFit];
    return label;
}

#pragma mark - UILabel在指定的地方换行
-(void)funcUILabelNextLine
{
    // 换行符为\n,在需要换行的地方加上这个符号即可，如
    label.numberOfLines = 0;
    label.text = @"此处\n换行";
}

#pragma mark - UILabel在指定的宽度下，自动设置最佳font
-(void)funcUILabelSetFont
{
    label.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - UILabel在指定字体下，自动设置 size
-(void)funcUILabelSizeToFit
{
    [label sizeToFit];
}

#pragma mark - UILabel设置行间距
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

#pragma mark - UILabel计算label上某段文字的frame
- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[label attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[label bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

#pragma mark - 动画修改label上的文字
-(void)funcInsertTextWithAnimation
{
    // 方法一
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.75;
    [label.layer addAnimation:animation forKey:@"kCATransitionFade"];
    label.text = @"New";
    
    // 方法二
    [UIView transitionWithView:label
                      duration:0.25f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        label.text = @"Well done!";
                    } completion:nil];
    
    // 方法三
    [UIView animateWithDuration:1.0
                     animations:^{
                         label.alpha = 0.0f;
                         label.text = @"newText";
                         label.alpha = 1.0f;
                     }];
}

#pragma mark - UILabel的文字内容显示在左上／右上／左下／右下／中心顶／中心底部
//自定义UILabel
//重写label的textRectForBounds方法
/*
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.textAlignmentType) {
        case WZBTextAlignmentTypeLeftTop: {
            rect.origin = bounds.origin;
        }
            break;
        case WZBTextAlignmentTypeRightTop: {
            rect.origin = CGPointMake(CGRectGetMaxX(bounds) - rect.size.width, bounds.origin.y);
        }
            break;
        case WZBTextAlignmentTypeLeftBottom: {
            rect.origin = CGPointMake(bounds.origin.x, CGRectGetMaxY(bounds) - rect.size.height);
        }
            break;
        case WZBTextAlignmentTypeRightBottom: {
            rect.origin = CGPointMake(CGRectGetMaxX(bounds) - rect.size.width, CGRectGetMaxY(bounds) - rect.size.height);
        }
            break;
        case WZBTextAlignmentTypeTopCenter: {
            rect.origin = CGPointMake((CGRectGetWidth(bounds) - CGRectGetWidth(rect)) / 2, CGRectGetMaxY(bounds) - rect.origin.y);
        }
            break;
        case WZBTextAlignmentTypeBottomCenter: {
            rect.origin = CGPointMake((CGRectGetWidth(bounds) - CGRectGetWidth(rect)) / 2, CGRectGetMaxY(bounds) - CGRectGetMaxY(bounds) - rect.size.height);
        }
            break;
        case WZBTextAlignmentTypeLeft: {
            rect.origin = CGPointMake(0, rect.origin.y);
        }
            break;
        case WZBTextAlignmentTypeRight: {
            rect.origin = CGPointMake(rect.origin.x, 0);
        }
            break;
        case WZBTextAlignmentTypeCenter: {
            rect.origin = CGPointMake((CGRectGetWidth(bounds) - CGRectGetWidth(rect)) / 2, (CGRectGetHeight(bounds) - CGRectGetHeight(rect)) / 2);
        }
            break;
            
        default:
            break;
    }
    return rect;
}
 */

#pragma mark - UILabel设置内边距
//子类化UILabel，重写drawTextInRect方法

/*
- (void)drawTextInRect:(CGRect)rect {
    // 边距，上左下右
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
 */

#pragma mark - UILabel设置文字描边
//子类化UILabel，重写drawTextInRect方法
/*
- (void)drawTextInRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    // 设置描边宽度
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    // 描边颜色
    self.textColor = [UIColor redColor];
    [super drawTextInRect:rect];
    // 文本颜色
    self.textColor = [UIColor yellowColor];
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
}
 */




@end
