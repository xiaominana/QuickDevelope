//
//  NetAPIRequest.m
//  NewProject
//
//  Created by huangliru on 2017/7/25.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import "NetAPIRequest.h"
#import "MBProgressHUD+MJ.h"
#import "JSONKit.h"
#import "DBHelper.h"
#import "NSObject+AutoCoding.h"

@implementation NetAPIRequest

+ (NetAPIRequest *)sharedJsonClient
{
    static NetAPIRequest *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[NetAPIRequest alloc] initWithBaseURL:[NSURL URLWithString:kService_Code_BaseUrl]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self = [super initWithBaseURL:url sessionConfiguration:config];
    if (!self) {
        return nil;
    }
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    [self.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    self.requestSerializer.timeoutInterval = 30;
    
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                withProgressHUD:(BOOL)progressHUD
                       andBlock:(void (^)(id data, NSError *error))block{
    //log请求数据
    DebugLog(@"\n===========request===========\n%@    \n%@", aPath, params);
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (progressHUD)
    {
        [MBProgressHUD showSuccess:@""];
    }
    
    //发起请求
    switch (NetworkMethod) {
        case Get:{
            
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
                NSLog(@"totalCount = %lld\ncurrent = %lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"responseJSONKit===============\n%@",[responseObject JSONString]);
                
                //
                block(responseObject, nil);
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (isDev)
                {
                    
                }
                block(nil, error);
                NSLog(@"responseError================\n%@,",error);
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
            break;
        }
        case Post:{
            
            
            [self POST:aPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
                NSLog(@"=======下载总进度 totalCount = %lld\n=======下载当前进度 current = %lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"===============responseJSONKit===============\n%@",[responseObject JSONString]);
                NSLog(@"responseObject = %@",responseObject);
                
                block(responseObject,nil);
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                
                
                if (error.code == -1009)
                {
                    [DBHelper showMessage:@"您当前网络状况不佳，请稍后重试"];
                }
                else
                {
                    [DBHelper showMessage:@"数据有误，请稍后重试"];
                }
                
                block(nil, error);
                NSLog(@"responseError================\n%@,",error);
                
                
                // [MBProgressHUD hideGifImage];
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
            
            break;}
        case Put:{
            
            [self PUT:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                block(responseObject, nil);
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                block(nil, error);
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
            break;}
        case Delete:{
            
            [self DELETE:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                block(responseObject, nil);
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                block(nil, error);
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
        }
        default:
            break;
    }
}

-(void)requestFormDataWithPaht:(NSString *)aPath
                    withParams:(NSDictionary*)params
                      withData:(NSDictionary<NSString *,NSData *> *)data
                withMethodType:(int)NetworkMethod
               withProgressHUD:(BOOL)progressHUD
                      andBlock:(void (^)(id data, NSError *error))block
{
    DebugLog(@"\n===========request===========\n%@    \n%@", aPath, params);
    
    
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (progressHUD)
    {
        [MBProgressHUD showSuccess:@""];
    }
    [self POST:aPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSString *key in data.allKeys)
        {
            [formData appendPartWithFileData:data[key] name:key fileName:@"测试.jpg" mimeType:@""];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"=======下载总进度 totalCount = %lld\n=======下载当前进度 current = %lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"===============responseJSONKit===============\n%@",[responseObject JSONString]);
        NSLog(@"responseObject = %@",responseObject);
        
        block(responseObject,nil);
        
        [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == -1009)
        {
            [DBHelper showMessage:@"您当前网络状况不佳，请稍后重试"];
        }
        else
        {
            [DBHelper showMessage:@"数据有误，请稍后重试"];
        }
        
        block(nil, error);
        NSLog(@"responseError================\n%@,",error);
        
        
        [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
        
    }];
}


-(void)requsetJsonObjectWithPath:(NSString *)aPath
                      withParams:(NSDictionary *)params
                withObjectClassz:(Class)classz
                  withMethodType:(int)NetworkMethod
                 withProgressHUD:(BOOL)progressHUD
                        andBlock:(void (^)(id data, NSError *error))block
{
    //log请求数据
    DebugLog(@"\n===========request===========\n%@    \n%@", aPath, params);
    
    
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (progressHUD)
    {
        [MBProgressHUD showSuccess:@""];
    }
    
    //发起请求
    switch (NetworkMethod) {
        case Get:{
            
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
                NSLog(@"totalCount = %lld\ncurrent = %lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"responseJSONKit===============\n%@",[responseObject JSONString]);
                
                
                [self handleRequestResponseWithOperation:responseObject Error:nil LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (isDev)
                {
                    
                }
                [self handleRequestResponseWithOperation:nil Error:error LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                NSLog(@"responseError================\n%@,",error);
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
            break;
        }
        case Post:{
            
            
            [self POST:aPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
                NSLog(@"=======下载总进度 totalCount = %lld\n=======下载当前进度 current = %lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"===============responseJSONKit===============\n%@",[responseObject JSONString]);
                NSLog(@"responseObject = %@",responseObject);
                
                [self handleRequestResponseWithOperation:responseObject Error:nil LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
                //[MBProgressHUD hideGifImage];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                
                
                if (error.code == -1009)
                {
                    [DBHelper showMessage:@"您当前网络状况不佳，请稍后重试"];
                }
                else
                {
                    [DBHelper showMessage:@"数据有误，请稍后重试"];
                }
                
                [self handleRequestResponseWithOperation:nil Error:error LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                NSLog(@"responseError================\n%@,",error);
                
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
            
            break;}
        case Put:{
            
            [self PUT:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleRequestResponseWithOperation:responseObject Error:nil LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handleRequestResponseWithOperation:nil Error:error LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
            break;}
        case Delete:{
            
            [self DELETE:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleRequestResponseWithOperation:responseObject Error:nil LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handleRequestResponseWithOperation:nil Error:error LoadingFlag:progressHUD withObjectClassz:classz andBlock:block];
                [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
                
            }];
            
        }
        default:
            break;
    }
}

-(void)handleRequestResponseWithOperation:(id)task
                                    Error:(NSError*)error
                              LoadingFlag:(BOOL)isLoading
                         withObjectClassz:(Class)classz
                                 andBlock:(void (^)(id data, NSError *error))block
{
    if (error)
    {
        block(nil,error);
    }
    else
    {
        id object = [classz ac_objectWithAny:task];
        block(object,nil);
        
    }
}

@end
