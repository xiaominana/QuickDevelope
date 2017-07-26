//
//  DBHelp.h
//  DBClub_IOS
//
//  Created by 刘世财 on 15/1/26.
//  Copyright (c) 2015年 搭伴科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DBHelper : NSObject

+ (instancetype)sharedAppHelper;

/**
 *  处理返回数据
 *
 *  @param dict 返回的数据
 *
 *  @return 处理的数据
 */
+(NSDictionary *)setData:(NSDictionary *)dict;


/**
 *  弹出提示框仿Android提示
 *
 *  @param message 无返回值
 */
+(void)showMessage:(NSString *)message;


/**
 *  验证护照
 *
 *  @param value 需要验证的护照
 *
 *  @return 是否是正确的护照
 */
+ (BOOL) isValidPassport:(NSString*)value;

/**
 *  验证是否只包含汉字或者字母
 *
 *  @param str 需要验证的zifc
 *
 *  @return 该字符串是否满足要求
 */
+ (BOOL)isChineseOrLetter:(NSString *)str;

/**
 *  验证身份证号
 *
 *  @param value 需要验证的身份证号
 *
 *  @return 是否是正确的身份证号
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

/**
 *  进行MD5加密
 *
 *  @param inPutText 需要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *) md5: (NSString *) inPutText;

/**
 *  验证手机号码
 *
 *  @param tel 需要验证的手机号码
 *
 *  @return 是否是手机号码
 */
+ (BOOL)isValidateTel:(NSString *)tel;

/**
 *  验证密码6-16位数字或字母
 *
 *  @param candidate 需要验证的密码
 *
 *  @return 是否是需要的密码
 */
+ (BOOL) validatePWD: (NSString *) candidate;

/**
 *  验证是否为纯数字
 *
 *  @param number 需要验证的字符串
 *
 *  @return 是否是纯数字
 */
+(BOOL)validateNumber:(NSString *)number;

/**
 *  验证邮箱
 *
 *  @param mail 需要验证的邮箱
 *
 *  @return 是否是邮箱
 */
+(BOOL)validateMail:(NSString *)mail;

//检测是否为中文
+ (BOOL) validateChinese:(NSString *)str;

+(NSString *)getTimeWithDate:(NSString *)date;



/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;


+(void)setCount:(NSString *)count inView:(UIView *)view;

/**
 *  获取指定日期的时间
 *
 *  @param date 指定的日期
 *
 *  @return 返回规定的时间
 */
+(NSDateComponents *)getDateComonents:(NSDate *)date comonents:(NSCalendarUnit)comonents;

@end
