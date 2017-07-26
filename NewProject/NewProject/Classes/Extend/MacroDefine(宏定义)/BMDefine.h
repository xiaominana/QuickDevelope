//
//  BMDefine.h
//  NewProject
//  常用变量宏定义
//  Created by huangliru on 2017/7/25.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#ifndef BMDefine_h
#define BMDefine_h


#define iPhone4  [UIScreen mainScreen].bounds.size.height == 480
#define iPhone5  [UIScreen mainScreen].bounds.size.height == 568
#define iPhone6  [UIScreen mainScreen].bounds.size.height == 667
#define iPhone6p  [UIScreen mainScreen].bounds.size.height == 736
#define iPhone7  [UIScreen mainScreen].bounds.size.height == 667
#define iPhone7p  [UIScreen mainScreen].bounds.size.height == 736
#define ScreenWidth    [UIScreen mainScreen].bounds.size.width
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height

//用来处理1像素的线
#define SINGLE_LINE_WIDTH   (1 / [UIScreen mainScreen].scale)

/**
 *  字体大小
 *
 *  @param font 字体大小与系统提供的一致
 *
 *  @return 返回系统方法提供的字体大小
 */
#define DEF_SFont10     [UIFont systemFontOfSize:10]
#define DEF_SFont11     [UIFont systemFontOfSize:11]
#define DEF_SFont12     [UIFont systemFontOfSize:12]
#define DEF_SFont13     [UIFont systemFontOfSize:13]
#define DEF_SFont14     [UIFont systemFontOfSize:14]
#define DEF_SFont15     [UIFont systemFontOfSize:15]
#define DEF_SFont16     [UIFont systemFontOfSize:16]
#define DEF_SFont17     [UIFont systemFontOfSize:17]
#define DEF_SFont18     [UIFont systemFontOfSize:18]
#define DEF_SFont19     [UIFont systemFontOfSize:19]
#define DEF_SFont20     [UIFont systemFontOfSize:20]


#define DEF_BFont10     [UIFont boldSystemFontOfSize:10]
#define DEF_BFont11     [UIFont boldSystemFontOfSize:11]
#define DEF_BFont12     [UIFont boldSystemFontOfSize:12]
#define DEF_BFont13     [UIFont boldSystemFontOfSize:13]
#define DEF_BFont14     [UIFont boldSystemFontOfSize:14]
#define DEF_BFont15     [UIFont boldSystemFontOfSize:15]
#define DEF_BFont16     [UIFont boldSystemFontOfSize:16]
#define DEF_BFont17     [UIFont boldSystemFontOfSize:17]
#define DEF_BFont18     [UIFont boldSystemFontOfSize:18]
#define DEF_BFont19     [UIFont boldSystemFontOfSize:19]
#define DEF_BFont20     [UIFont boldSystemFontOfSize:20]
#define DEF_BFont21     [UIFont boldSystemFontOfSize:21]
#define DEF_BFont22     [UIFont boldSystemFontOfSize:22]
#define DEF_BFont23     [UIFont boldSystemFontOfSize:23]
#define DEF_BFont24     [UIFont boldSystemFontOfSize:24]

/**
 *    字体大小
 */
#define DEF_SFont(font) [UIFont systemFontOfSize:font]
#define DEF_BFont(font) [UIFont boldSystemFontOfSize:font]


/**
 *  @brief 获取一个控件的最大Y坐标
 *
 *  @param view 视图对象
 *
 *  @return Y坐标
 */
#define DEF_FRAME_MAX_Y(view) CGRectGetMaxY(view.frame)
/**
 *  @brief 获取一个控件的最小Y坐标
 *
 *  @param view 视图对象
 *
 *  @return Y坐标
 */
#define DEF_FRAME_MIN_Y(view) view.frame.origin.y

/**
 *  @brief 获取一个控件的最大X坐标
 *
 *  @param view 视图对象
 *
 *  @return X坐标
 */
#define DEF_FRAME_MAX_X(view) CGRectGetMaxX(view.frame)

/**
 *  @brief 获取一个控件的最小X坐标
 *
 *  @param view 视图对象
 *
 *  @return X坐标
 */
#define DEF_FRAME_MIN_X(view) view.frame.origin.x

/**
 *  @brief 获取一个控件的宽度
 *
 *  @param view 视图对象
 *
 *  @return 宽度
 */
#define DEF_FRAME_W(view) view.frame.size.width

/**
 *  @brief 获取一个控件的高度
 *
 *  @param view 视图对象
 *
 *  @return 高度
 */
#define DEF_FRAME_H(view) view.frame.size.height

/**
 *  获取一个控件中间Y坐标
 *
 *  @param view 视图对象
 *
 *  @return 中间Y坐标
 */
#define DEF_FRAME_MID_Y(view)   CGRectGetMidY(view.frame)


/**
 *  获取一个控件中间X坐标
 *
 *  @param view 视图对象
 *
 *  @return 中间X坐标
 */
#define DEF_FRAME_MID_X(view)   CGRectGetMidX(view.frame)

/**
 *  @brief 设置一个控件的X坐标
 *
 *  @param view 视图对象
 *
 *  @return void
 */
#define DEF_SET_FRAME_X(view,x) view.frame = CGRectMake(x,view.frame.origin.y,view.frame.size.width,view.frame.size.height)

/**
 *  @brief 设置一个控件的Y坐标
 *
 *  @param view 视图对象
 *
 *  @return void
 */
#define DEF_SET_FRAME_Y(view,y) view.frame = CGRectMake(view.frame.origin.x, y,view.frame.size.width,view.frame.size.height)

/**
 *  @brief 设置一个控件的高度
 *
 *  @param view 视图对象
 *
 *  @return void
 */
#define DEF_SET_FRAME_H(view,h) view.frame = CGRectMake(view.frame.origin.x,view.frame.origin.y,view.frame.size.width, h);

/**
 *  @brief 设置一个控件的宽度
 *
 *  @param view 视图对象
 *
 *  @return void
 */
#define DEF_SET_FRAME_W(view,w) view.frame = CGRectMake(view.frame.origin.x,view.frame.origin.y,w,view.frame.size.height);

/**
 *	@brief	设置分割线颜色
 */
#define DEF_LineColor [UIColor colorWithHexString:@"dcdcdc"]

/**
 *	@brief	视图背景颜色
 */
#define DEF_ViewBackColor HEXCOLOR(@"f0f0f0")

#define RGBCOLOR(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define HEXCOLOR(color) [UIColor colorWithHexString:color]
/**
 *	@brief	应用主题色
 */
#define DEF_MainThemeColor  HEXCOLOR(@"0x007aff")

#endif /* BMDefine_h */
