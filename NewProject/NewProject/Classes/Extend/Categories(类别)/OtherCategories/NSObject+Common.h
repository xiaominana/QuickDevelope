//
//  NSObject+Common.h
//  LPBM
//
//  Created by 赵文龙 on 15/3/3.
//  Copyright (c) 2015年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface NSObject (Common)

#pragma mark Tip M
- (NSString *)tipFromError:(NSError *)error;


-(void)removeProgressHUD;




@end
