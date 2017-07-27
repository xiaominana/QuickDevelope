//
//  NSObject+Common.m
//  LPBM
//
//  Created by 赵文龙 on 15/3/3.
//  Copyright (c) 2015年 BM. All rights reserved.
//

#import "NSObject+Common.h"


@implementation NSObject (Common)

#pragma mark Tip M
- (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"]) {
            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
            NSUInteger num = [msgArray count];
            for (int i = 0; i < num; i++) {
                NSString *msgStr = [msgArray objectAtIndex:i];
                if (i+1 < num) {
                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                }else{
                    [tipStr appendString:msgStr];
                }
            }
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

#pragma mark 显示错误消息
//- (void)showError:(NSError *)error{
//    if ([JDStatusBarNotification isVisible]) {//如果statusBar上面正在显示信息，则不再用hud显示error
//        NSLog(@"如果statusBar上面正在显示信息，则不再用hud显示error");
//        return;
//    }
//    NSString *tipStr = [self tipFromError:error];
//    [self showHudTipStr:tipStr];
//}

-(MBProgressHUD *)getProgressHUD
{
    static MBProgressHUD *sharedHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
    });
    
    return sharedHUD;
}

- (void)showHudTipStr:(NSString *)tipStr{
  
    if (tipStr && tipStr.length > 0) {
        [self getProgressHUD].hidden = NO;
//        [self getProgressHUD].mode = MBProgressHUDModeText;
        [self getProgressHUD].label.text = tipStr;
        [self getProgressHUD].mode = MBProgressHUDModeDeterminate;
        [self getProgressHUD].margin = 10.f;
        [self getProgressHUD].removeFromSuperViewOnHide = YES;
    }
}
 
-(void)removeProgressHUD
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getProgressHUD].hidden = YES;
    });
}



@end
