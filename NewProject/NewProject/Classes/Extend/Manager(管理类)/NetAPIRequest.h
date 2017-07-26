//
//  NetAPIRequest.h
//  NewProject
//
//  Created by huangliru on 2017/7/25.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface NetAPIRequest : AFHTTPSessionManager

+ (NetAPIRequest *)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                withProgressHUD:(BOOL)progressHUD
                       andBlock:(void (^)(id data, NSError *error))block;

-(void)requestFormDataWithPaht:(NSString *)aPath
                    withParams:(NSDictionary*)params
                      withData:(NSDictionary<NSString *,NSData *> *)data
                withMethodType:(int)NetworkMethod
               withProgressHUD:(BOOL)progressHUD
                      andBlock:(void (^)(id data, NSError *error))block;

-(void)requsetJsonObjectWithPath:(NSString *)aPath
                      withParams:(NSDictionary *)params
                withObjectClassz:(Class)classz
                  withMethodType:(int)NetworkMethod
                 withProgressHUD:(BOOL)progressHUD
                        andBlock:(void (^)(id data, NSError *error))block;

@end
