//
//  NetAPIManager.h
//  NewProject
//
//  Created by huangliru on 2017/7/25.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetAPIRequest.h"
@interface NetAPIManager : NSObject

+ (instancetype)sharedManager;

/**
 *  发送一个POST请求
 *
 *  @param path     请求URL
 *  @param params  参数
 *  @param progressHUD 是否需要提示框
 *  @param block 返回block
 */
-(void)requset_getAllPath:(NSString *)path withParams:(NSDictionary *)params withProgressHUD:(BOOL)progressHUD andBlock:(void (^)(NSDictionary *responseData, NSError *error))block;

/**
 *  发送一个POST请求,(图片,文件请求)
 *
 *  @param path     请求URL
 *  @param params  参数
 *  @param data    文件data
 *  @param progressHUD 是否需要提示框
 *  @param block 返回block
 */
-(void)requset_formDataPath:(NSString *)path withParams:(NSDictionary *)params withData:(NSDictionary<NSString *,NSData *> *)data withProgressHUD:(BOOL)progressHUD andBlock:(void (^)(NSDictionary *responseData, NSError *error))block;
@end
