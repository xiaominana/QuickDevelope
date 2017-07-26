//
//  UITableViewCell+DataSource.h
//  qxt
//
//  Created by 赵文龙 on 2016/10/12.
//  Copyright © 2016年 赵文龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (DataSource)

-(void)initView;
-(void)setDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath;
-(void)setObject:(id)object indexPath:(NSIndexPath *)indexPath;

@end
