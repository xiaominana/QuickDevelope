//
//  DBHelp.m
//  DBClub_IOS
//
//  Created by 刘世财 on 15/1/26.
//  Copyright (c) 2015年 搭伴科技. All rights reserved.
//

#import "DBHelper.h"
#import "CommonCrypto/CommonDigest.h"

static id _instance;

@interface DBHelper()<UIAlertViewDelegate>



@end

@implementation DBHelper

+ (instancetype)sharedAppHelper
{
    @synchronized(self) {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+(id)setData:(id)object
{
    if ([object isKindOfClass:[NSArray class]])
    {
        return [self setArray:object];
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        return [self setDict:object];
    }
    return object;
}

+(NSMutableDictionary *)setDict:(NSDictionary *)dict
{
    NSMutableDictionary *dDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    for (NSString *key in dDict.allKeys)
    {
        if ([dDict[key] isKindOfClass:[NSNull class]])
        {
            [dDict setObject:@"" forKey:key];
        }
        else if ([dDict[key] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array = [self setArray:dDict[key]];
            [dDict setObject:array forKey:key];
        }
        else if ([dDict[key] isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary *dict1 = [self setDict:dDict[key]];
            [dDict setObject:dict1 forKey:key];
        }
    }
    return dDict;
}

+(NSMutableArray *)setArray:(NSArray *)array
{
    NSMutableArray *subArray = [[NSMutableArray alloc] initWithArray:array];
    for (int i=0; i<subArray.count; i++)
    {
        if ([subArray[i] isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary *subDict = [self setDict:subArray[i]];
            [subArray replaceObjectAtIndex:i withObject:subDict];
        }
        else if ([subArray[i] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array1 = [self setArray:subArray[i]];
            [subArray replaceObjectAtIndex:i withObject:array1];
        }
        else if ([subArray[i] isKindOfClass:[NSNull class]])
        {
            [subArray replaceObjectAtIndex:i withObject:@""];
        }
        
    }
    return subArray;
}


+(void)showMessage:(NSString *)message
{
    if ([message isEqualToString:@""])
    {
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview = [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 290, 20)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [label sizeToFit];
    [showview addSubview:label];
    showview.frame = CGRectMake((ScreenWidth - DEF_FRAME_W(label) - 20)/2, ScreenHeight- 100, DEF_FRAME_W(label)+20, DEF_FRAME_H(label)+10);
    [UIView animateWithDuration:4 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
        }];
}



void TTAlertNoTitle(NSString* message) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - 验证手机号码和电话号码的正则表达式
+ (BOOL)isValidateTel:(NSString *)tel
{
    //电话号码正则表达式（支持手机号码，3-4位区号，7-8位直播号码，1－4位分机号）
//    NSString *regex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(177)|(18[0-9]))\\d{8}$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    return [telTest evaluateWithObject:tel];
}

#pragma mark - 验证是否只包含汉字和字母
+ (BOOL)isChineseOrLetter:(NSString *)str
{
    //电话号码正则表达式（支持手机号码，3-4位区号，7-8位直播号码，1－4位分机号）
    //    NSString *regex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    //NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5]+";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    return [telTest evaluateWithObject:str];
}


#pragma mark -验证密码 6~16位数字或字母
+ (BOOL) validatePWD: (NSString *) candidate {
    NSString *pwdRegex = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    return [pwdTest evaluateWithObject:candidate];
}

+(BOOL)validateNumber:(NSString *)number
{
    NSString *pwdRegex = @"^[0-9]$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    return [pwdTest evaluateWithObject:number];
}

+(BOOL)validateMail:(NSString *)mail
{
//    NSString *mailRegex = @"^[A-Za-zd]+([-_.][A-Za-zd]+)*@([A-Za-zd]+[-.])+[A-Za-zd]{2,5}$";
    NSString *mailRegex = @"^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
    NSPredicate *mailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mailRegex];
    
    return [mailTest evaluateWithObject:mail];
    
}

+ (BOOL)validateIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

#pragma mark - 校验护照
+ (BOOL) isValidPassport:(NSString*)value
{
    const char *str = [value UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G'))
    {
        return FALSE;
    }
    if (first == 'P')
    {
        if (length != 8)
        {
            return FALSE;
        }
    }
    if (first == 'G')
    {
        if (length != 9)
        {
            return FALSE;
        }
    }
    BOOL result = TRUE;
    for (NSInteger i = 1; i < length; i++)
    {
        if (!(str[i] >= '0' && str[i] <= '9'))
        {
            result = FALSE;
            break;
        }
    }
    return result;
}

#pragma mark 检测是否为中文
+ (BOOL) validateChinese:(NSString *)str
{
    NSString *pwdRegex = @"^[\u4E00-\u9FA5]*$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    return [pwdTest evaluateWithObject:str];
}


+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+(NSString *)getTimeWithDate:(NSString *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * d = [dateFormatter dateFromString:date];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚"];
            
        }else{
            
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    
    
    if (cha/86400 > 1)
        
    {
        NSTimeInterval secondPerDay = 24*60*60;
        
        NSDate * yesterDay = [NSDate dateWithTimeIntervalSinceNow:-secondPerDay];
        
        NSDate * beforeYesterDay = [NSDate dateWithTimeIntervalSinceNow:-2*secondPerDay];
        
        NSCalendar * calendar = [NSCalendar currentCalendar];
        
        unsigned uintFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        
        NSDateComponents * souretime = [calendar components:uintFlags fromDate:d];
        
        NSDateComponents * yesterday = [calendar components:uintFlags fromDate:yesterDay];
        
        NSDateComponents *beforeYesterDay_ = [calendar components:uintFlags fromDate:beforeYesterDay];
        
        if (souretime.year == yesterday.year && souretime.month == yesterday.month && souretime.day == yesterday.day){
            
            [dateFormatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"昨天 %@  ",[dateFormatter stringFromDate:d]];
        }
        else if(souretime.year == beforeYesterDay_.year && souretime.month == beforeYesterDay_.month && souretime.day == beforeYesterDay_.day)
        {
            [dateFormatter setDateFormat:@"HH:mm"];
            
            timeString = [NSString stringWithFormat:@"前天 %@  ",[dateFormatter stringFromDate:d]];
        }
        else
        {
            int num = cha/84600;
            
            [dateFormatter setDateFormat:@"HH:mm"];
            
            NSLog(@"num num num num == %d",num);
            
            timeString = [NSString stringWithFormat:@"%d天前 %@  ",num,[dateFormatter stringFromDate:d]];
            
        }
    }
    
    return timeString;
}

//适配按比例计算控件大小和位置
+(CGRect)setFrameWith:(CGRect)RectMake
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    
    if(ScreenHeight > 480){
        autoSizeScaleX = ScreenWidth/320;
        autoSizeScaleY = ScreenHeight/568;
    }else{
        autoSizeScaleX = 1.0;
        autoSizeScaleY = 1.0;
    }
    
    CGRect rect;
    rect.origin.x = RectMake.origin.x * autoSizeScaleX;
    rect.origin.y = RectMake.origin.y * autoSizeScaleY;
    
    rect.size.width = RectMake.size.width * autoSizeScaleX;
    rect.size.height = RectMake.size.height * autoSizeScaleY;
    
    return rect;
}

+(CGSize)setSizeWith:(CGSize)sizeMake
{
    float autoSizeScaleX;
    float autoSizeScaleY;
    
    if(ScreenHeight > 480){
        autoSizeScaleX = ScreenWidth/320;
        autoSizeScaleY = ScreenHeight/568;
    }else{
        autoSizeScaleX = 1.0;
        autoSizeScaleY = 1.0;
    }
    
    CGSize size;
    size.width = sizeMake.width * autoSizeScaleX;
    size.height = sizeMake.height * autoSizeScaleY;
    
    return size;
}

+(CGFloat)setAutoY:(CGFloat )y
{
    float autoSizeScaleY;
    
    if(ScreenHeight > 480){
        autoSizeScaleY = ScreenHeight/568;
    }else{
        autoSizeScaleY = 1.0;
    }
    
    return y*autoSizeScaleY;
}

+(CGFloat)setAutoX:(CGFloat )x
{
    float autoSizeScaleX;
    
    if(ScreenHeight > 480){
        autoSizeScaleX = ScreenHeight/320;
    }else{
        autoSizeScaleX = 1.0;
    }
    
    return x*autoSizeScaleX;
}

+(CGFloat)setAutoHeight:(CGFloat)height
{
    float autoSizeScaleY;
    
    if(ScreenHeight > 480){
        autoSizeScaleY = ScreenHeight/568;
    }else{
        autoSizeScaleY = 1.0;
    }
    
    return height*autoSizeScaleY;
    
}

+(CGFloat)setAutoWidth:(CGFloat)width
{
    float autoSizeScaleY;

    if(ScreenHeight > 480){
        autoSizeScaleY = ScreenHeight/568;
    }else{
        autoSizeScaleY = 1.0;
    }
    
    return width*autoSizeScaleY;
    
}

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}



+(void)setCount:(NSString *)count inView:(UIView *)view
{
    UIImageView *imageView = [view viewWithTag:201606];
    UILabel *label = [imageView viewWithTag:100];
    label.text = count;
}

/**
 *  获取指定日期的时间
 *
 *  @param date 指定的日期
 *
 *  @return 返回规定的时间
 */
+(NSDateComponents *)getDateComonents:(NSDate *)date comonents:(NSCalendarUnit)comonents
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *com = [calendar components:comonents fromDate:date];
    return com;
}

@end
