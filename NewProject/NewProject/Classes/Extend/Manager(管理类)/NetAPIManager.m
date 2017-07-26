//
//  NetAPIManager.m
//  NewProject
//
//  Created by huangliru on 2017/7/25.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import "NetAPIManager.h"

@implementation NetAPIManager
+ (instancetype)sharedManager {
    static NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)requset_getAllPath:(NSString *)path withParams:(NSDictionary *)params withProgressHUD:(BOOL)progressHUD andBlock:(void (^)(NSDictionary *responseData, NSError *error))block;
{
    [[NetAPIRequest sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post withProgressHUD:progressHUD andBlock:^(id responseData, NSError *error) {
        
        if(responseData)
        {
            block(responseData,nil);
        }
        else
        {
            block(nil,error);
        }
        
    }];
}

-(void)requset_formDataPath:(NSString *)path withParams:(NSDictionary *)params withData:(NSDictionary<NSString *,NSData *> *)data withProgressHUD:(BOOL)progressHUD andBlock:(void (^)(NSDictionary *responseData, NSError *error))block
{
    [[NetAPIRequest sharedJsonClient] requestFormDataWithPaht:path withParams:params withData:data withMethodType:Post withProgressHUD:progressHUD andBlock:^(id data, NSError *error) {
        
        if(data)
        {
            block(data,nil);
        }
        else
        {
            block(nil,error);
        }
        
    }];
}


@end
