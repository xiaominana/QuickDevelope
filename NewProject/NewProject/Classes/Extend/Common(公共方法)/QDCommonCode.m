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


#pragma mark - ************ CGRect/CGSize/CGPoint ************
CGRect rect1, rect2, rect;
CGSize size1, size2, size;
CGPoint point1, point2, point;

#pragma mark - 比较两个CGRect/CGSize/CGPoint是否相等
-(void)compareTwoCGRectCGSizeCGPoint
{
    if (CGRectEqualToRect(rect1, rect2)) { // 两个区域相等
        // do some
    }
    if (CGPointEqualToPoint(point1, point2)) { // 两个点相等
        // do some
    }
    if (CGSizeEqualToSize(size1, size2)) { // 两个size相等
        // do some
    }
}

#pragma mark - 检查一个rect是否包含一个point
-(BOOL)pointInRect
{
    // point是否在rect内
    return CGRectContainsPoint(rect, point);
}

#pragma mark - 判断两个rect是否有交叉
-(void)rectIntersectsRect
{
    if (CGRectIntersectsRect(rect1, rect2)){}
}


#pragma mark - ************ NSDate ************
NSDate * date;
NSDate * date1;
NSDate * date2;

#pragma mark - 比较两个NSDate相差多少小时
-(void)compareTwoDateByHour
{
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInAnHour = 3600;
    // 除以3600是把秒化成小时，除以60得到结果为相差的分钟数
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
}

#pragma mark - 判断NSDate是不是今天
-(void)dateIsToday
{
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        // 是今天
    }
}

#pragma mark - 比较NSDate和当前时间谁大
/************
 日期格式请传入：2013-08-05 12:12:12；如果修改日期格式，比如：2013-08-05，则将[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];修改为[df setDateFormat:@"yyyy-MM-dd"];
 ***********/
-(int)compareDateByNow:(NSString*)date
{
    
    int ci = 0;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date];
    dt2 = [NSDate date];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //现在比传入大 已过期
        case NSOrderedAscending: ci=1;break;
            //现在比传入小 未过期
        case NSOrderedDescending: ci=-1;break;
            //现在=传入
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}


#pragma mark - ************ NSString ************
NSString * string;
NSString * str;
NSString * str1;
NSString * str2;

#pragma mark - 字符串是否为空
+ (BOOL)isEqualToNil:(NSString *)str
{
    return str.length <= 0 || [str isEqualToString:@""] || !str;
}

#pragma mark - 判断一个字符串是否为数字
-(void)stringIsNumber
{
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // 是数字
    } else
    {
        // 不是数字
    }
}

#pragma mark - 判断一个字符串是否包含另一个字符串
-(void)stringContainsString
{
    // 方法一、这种方法只适用于iOS8之后，如果是配iOS8之前用方法二
    if ([str containsString:string]) NSLog(@"包含");
    
    // 方法二
    NSRange range = [str rangeOfString:string];
    if (range.location != NSNotFound) NSLog(@"包含");
    
    // 方法1
    if ([str1 containsString:str2]) {
        NSLog(@"str1包含str2");
    } else {
        NSLog(@"str1不包含str2");
    }
    
    // 方法2
    if ([str1 rangeOfString: str2].location == NSNotFound) {
        NSLog(@"str1不包含str2");
    } else {
        NSLog(@"str1包含str2");
    }
}

#pragma mark - 处理字符串，使其首字母大写
-(void)BigFitstChar
{
    NSString *str = @"abcdefghijklmn";
    NSString *resultStr;
    if (str && str.length > 0) {
        resultStr = [str stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[str substringToIndex:1] capitalizedString]];
    }
    NSLog(@"%@", resultStr);
}

#pragma mark - 获取字符串中的数字

- (NSString *)getNumberFromStr:(NSString *)str
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}
//NSLog(@"%@", [self getNumberFromStr:@"a0b0c1d2e3f4fda8fa8fad9fsad23"]); // 00123488923

#pragma mark - 移除字符串中的空格和换行
+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

#pragma mark - 判断字符串中是否有空格
+ (BOOL)isBlank:(NSString *)str
{
    NSRange _range = [str rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        return YES;
    } else {
        //没有空格
        return NO;
    }
}

#pragma mark - 报错 : Attempt to mutate immutable object with insertString:atIndex:
//这个错是因为你拿字符串调用insertString:atIndex:方法的时候，调用对象不是NSMutableString，应该先转成这个类型再调用



#pragma mark - ************ UIViewController ************
UIViewController * viewController;
UIViewController * VC;

#pragma mark - 拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到
//用于获取应用当前活跃的 VC 的方法
+ (UIViewController *)getcurrentViewController{
    UIViewController *result = nil;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *tmpWin  in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}

#pragma mark - [ViewController aMethod:]: unrecognized selector sent to instance 0x7fe91e607fb0
//这是一个经典错误，ViewController不能响应aMethod这个方法，错误原因可能viewController文件中没有实现aMethod这个方法



#pragma mark - ************ UINavigationController ************
UINavigationController * navigationController;

#pragma mark - 设置navigationBar上的title颜色和大小
-(void)navigationBarTitle
{
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor greenColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}];
}

#pragma mark - 从导航控制器中删除某个控制器
-(void)removeViewControllerFromNavigationController
{
    // 方法一、知道这个控制器所处的导航控制器下标
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: navigationController.viewControllers];
    [navigationArray removeObjectAtIndex: 2];
    navigationController.viewControllers = navigationArray;
    
    // 方法二、知道具体是哪个控制器
    NSArray* tempVCA = [navigationController viewControllers];
    for(UIViewController *tempVC in tempVCA)
    {
        if([tempVC isKindOfClass:[UIViewController class]])
        {
            [tempVC removeFromParentViewController];
        }
    }
}

#pragma mark - 禁用系统滑动返回功能
/*
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
*/

#pragma mark - 获取当前导航控制器下前一个控制器
- (UIViewController *)backViewController
{
    NSInteger myIndex = [navigationController.viewControllers indexOfObject:self];
    
    if ( myIndex != 0 && myIndex != NSNotFound ) {
        return [navigationController.viewControllers objectAtIndex:myIndex-1];
    } else {
        return nil;
    }
}

#pragma mark - 让导航控制器pop回指定的控制器
-(void)popToVC{
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[UIViewController class]]) {
            [navigationController popToViewController:aViewController animated:NO];
        }
    }
}

#pragma mark - 页面跳转实现翻转动画
-(void)jumpAnimation
{
    // modal方式
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewController presentViewController:vc1 animated:YES completion:nil];

    // push方式
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor redColor];
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navigationController.view cache:NO];
    [navigationController pushViewController:vc2 animated:YES];
    [UIView commitAnimations];
}

#pragma mark - 让push跳转动画像modal跳转动画那样效果(从下往上推上来)
- (void)push
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [navigationController pushViewController:vc animated:NO];
}

- (void)pop
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [navigationController popViewControllerAnimated:NO];
}

#pragma mark - 设置下个页面的返回按钮的文字
-(void)insertNextVCBackButton
{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    //self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    viewController.navigationItem.backBarButtonItem = temporaryBarButtonItem;
}

#pragma mark - 设置系统导航栏左右按钮颜色
-(void)insertNavigationBarTintColor
{
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}



#pragma mark - ************ UIApplication ************

#pragma mark - 通知监听APP生命周期
/*
UIApplicationDidEnterBackgroundNotification 应用程序进入后台
UIApplicationWillEnterForegroundNotification 应用程序将要进入前台
UIApplicationDidFinishLaunchingNotification 应用程序完成启动
UIApplicationDidFinishLaunchingNotification 应用程序由挂起变的活跃
UIApplicationWillResignActiveNotification 应用程序挂起(有电话进来或者锁屏)
UIApplicationDidReceiveMemoryWarningNotification 应用程序收到内存警告
UIApplicationDidReceiveMemoryWarningNotification 应用程序终止(后台杀死、手机关机等)
UIApplicationSignificantTimeChangeNotification 当有重大时间改变(凌晨0点，设备时间被修改，时区改变等)
UIApplicationWillChangeStatusBarOrientationNotification 设备方向将要改变
UIApplicationDidChangeStatusBarOrientationNotification 设备方向改变
UIApplicationWillChangeStatusBarFrameNotification 设备状态栏frame将要改变
UIApplicationDidChangeStatusBarFrameNotification 设备状态栏frame改变
UIApplicationBackgroundRefreshStatusDidChangeNotification 应用程序在后台下载内容的状态发生变化
UIApplicationProtectedDataWillBecomeUnavailable 本地受保护的文件被锁定,无法访问
UIApplicationProtectedDataWillBecomeUnavailable 本地受保护的文件可用了
*/



@end
