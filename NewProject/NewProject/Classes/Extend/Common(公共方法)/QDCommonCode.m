//
//  QDCommonCode.m
//  NewProject
//
//  Created by 中盛锦华 on 2017/7/27.
//  Copyright © 2017年 huangliru. All rights reserved.
//

/*
    记住,任何已有的方案永远都不适用
    只要你有一秒的停顿,你就落后一秒
 */

#import "QDCommonCode.h"
#import <UIKit/UIKit.h>

@implementation QDCommonCode

#pragma mark - ************ UIView ************

UIView * view;

#pragma mark - UIView常用属性
+(UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}

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
//边框方向
typedef NS_ENUM(NSInteger, WZBBorderDirectionType) {
    WZBBorderDirectionTop = 0,  //顶部
    WZBBorderDirectionLeft,     //左边
    WZBBorderDirectionBottom,   //底部
    WZBBorderDirectionRight     //右边
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

#pragma mark - 约束如何做UIView动画
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

#pragma mark - 给一个view截图
-(UIImage *)screehshotForView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}


#pragma mark - ************ UILabel ************

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

#pragma mark - ************ UIImageView ************

UIImageView * imageView;

#pragma mark - UIImageView常用属性
+(UIImageView *)createimageViewWithFrame:(CGRect)frame image:(UIImage *)image contentMode:(UIViewContentMode)contentMode cornerRadius:(CGFloat)cornerRadius
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = image;
    imageView.contentMode = contentMode;
    imageView.layer.cornerRadius = cornerRadius;
    return imageView;
}

#pragma mark - 根据bundle中的图片名创建imageview

+ (UIImageView *)imageViewWithImageNamed:(NSString*)imageName
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

#pragma mark - 播放一张张连续的图片
-(void)playImages
{
    // 加入现在有三张图片分别为animate_1、animate_2、animate_3
    // 方法一
    imageView.animationImages = @[[UIImage imageNamed:@"animate_1"], [UIImage imageNamed:@"animate_2"], [UIImage imageNamed:@"animate_3"]];
    imageView.animationDuration = 1.0;
    // 方法二
    imageView.image = [UIImage animatedImageNamed:@"animate_" duration:1.0];
    // 方法二解释下，这个方法会加载animate_为前缀的，后边0-1024，也就是animate_0、animate_1一直到animate_1024
}

#pragma mark - 为imageView添加倒影
-(void)addReflectionForImageView:(UIImageView *)imageView
{
    CGRect frame = imageView.frame;
    frame.origin.y += (frame.size.height + 1);

    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.clipsToBounds = TRUE;
    reflectionImageView.contentMode = imageView.contentMode;
    [reflectionImageView setImage:imageView.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);

    CALayer *reflectionLayer = [reflectionImageView layer];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];

    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;

    [imageView.superview addSubview:reflectionImageView];
}

#pragma mark - 修改image颜色
-(void)insertImageColor
{
    UIImage *image = [UIImage imageNamed:@"test"];
    imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation: UIImageOrientationDownMirrored];
    imageView.image = flippedImage;
}

#pragma mark - 加载gif图片
//推荐使用这个框架 FLAnimatedImage


#pragma mark - ************ UIImage ************

UIImage * image;

#pragma mark - 获取图片资源
#define GetUIImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]


#pragma mark - 防止离屏渲染为image添加圆角 image圆角
// image分类
- (UIImage *)circleImage:(UIImage *)image
{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    // 方形变圆形
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片画上去
    [image drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - image拉伸
+ (UIImage *)resizableImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH * 0.5, imageW * 0.5, imageH * 0.5, imageW * 0.5) resizingMode:UIImageResizingModeStretch];
}

#pragma mark - 设置UIImage的透明度
// 方法一、添加UIImage分类
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha image:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
// 方法二、如果没有奇葩需求，干脆用UIImageView设置透明度
-(void)insertAlpha
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourImage"]];
    imageView.alpha = 0.5;
}

#pragma mark - 保存 UIImage 到本地
-(void)saveImageLocation:(UIImage *)image fileName:(NSString *)fileName/*加后缀如:@"ImageName.png",保存为 PNG 格式*/
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

#pragma mark 在image上绘制文字并生成新的image
-(UIImage *)drawText:(NSString *)text onImage:(UIImage *)image
{
    //字体
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIGraphicsBeginImageContext(image.size);
    //绘制 image
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    //定义文字的位置
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 比较两个UIImage是否相等
- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

#pragma mark - 取图片某一点的颜色
- (UIColor *)colorForPoint:(CGPoint)point inImage:(CGImageRef)CGImage
{
    if (point.x < 0 || point.y < 0) return nil;

    CGImageRef imageRef = CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    if (point.x >= width || point.y >= height) return nil;

    unsigned char *rawData = malloc(height * width * 4);
    
    if (!rawData) return nil;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast
                                                 | kCGBitmapByteOrder32Big);
    if (!context)
    {
        free(rawData);
        return nil;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;

    UIColor *result = nil;
    result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}

#pragma mark - 判断该图片是否有透明度通道
- (BOOL)hasAlphaChannelWithImage:(CGImageRef)CGImage
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

#pragma mark - 获得灰度图
+ (UIImage*)covertToGrayImageFromImage:(UIImage *)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) return nil;
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

#pragma mark - 根据bundle中的文件名读取图片

+ (UIImage *)imageWithFileName:(NSString *)name {
    NSString *extension = @"png";
    
    NSArray *components = [name componentsSeparatedByString:@"."];
    if ([components count] >= 2)
    {
        NSUInteger lastIndex = components.count - 1;
        extension = [components objectAtIndex:lastIndex];
        
        name = [name substringToIndex:(name.length-(extension.length+1))];
    }
    
    // 如果为Retina屏幕且存在对应图片，则返回Retina图片，否则查找普通图片
    if ([UIScreen mainScreen].scale == 2.0) {
        name = [name stringByAppendingString:@"@2x"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
        if (path != nil) {
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    
    if ([UIScreen mainScreen].scale == 3.0) {
        name = [name stringByAppendingString:@"@3x"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
        if (path != nil) {
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    }
    
    return nil;
}

#pragma mark - 画水印
// 画水印
- (UIImage *) setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    }
    //原图
    [image drawInRect:view.bounds];
    //水印图
    [mark drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

//画文字
- (void)drawTextInRect:(CGRect)rect
{
    CGRect textRect = [label textRectForBounds:rect limitedToNumberOfLines:label.numberOfLines];
    [label drawTextInRect:textRect];
}

#pragma mark - 获取图片大小
-(void)imageSize
{
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = imageWidth * image.scale;
}

#pragma mark - UIImage和base64互转
// view分类方法
- (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - 将一个image保存在相册中
-(void)saveImageInPhotos
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    //或者
    //#import <Photos/Photos.h>
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
//            changeRequest.creationDate          = [NSDate date];
//        } completionHandler:^(BOOL success, NSError *error) {
//            if (success) {
//                NSLog(@"successfully saved");
//            }
//            else {
//                NSLog(@"error saving to photos: %@", error);
//            }
//        }];
}

#pragma mark - 关于图片拉伸
//推荐看这个博客，讲的很详细：http://blog.csdn.net/q199109106q/article/details/8615661

#pragma mark - 上传图片太大，压缩图片
-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

#pragma mark - 颜色生成图片

+ (UIImage *)cl_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 判断图片类型
//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c)
    {
        case 0xFF:
            return @"jpeg";
            
        case 0x89:
            return @"png";
            
        case 0x47:
            return @"gif";
            
        case 0x49:
        case 0x4D:
            return @"tiff";
            
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"]
                && [testString hasSuffix:@"WEBP"])
            {
                return @"webp";
            }
            
            return nil;
    }
    return nil;
}

#pragma mark - 合并两个图片
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage
{
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 加载原始图片
+ (UIImage *)imageWithOriginalName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - 加载.9切片
+ (UIImage *)imageWithStretchableName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

#pragma mark - 渲染图片
-(UIImage*)tintedImage:(UIImage *)image WithColor:(UIColor*)color rect:(CGRect)rect level:(CGFloat)level
{
    CGRect imageRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, image.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [image drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, level);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:image.scale
                                       orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return darkImage;
}

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


//指定宽度按比例缩放
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}



















@end
