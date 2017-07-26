//
//  RootViewController.m
//  NewProject
//
//  Created by huangliru on 2017/7/25.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

+(void)crashAlert:(Class)style
{
    if (style == objc_getClass("__NSArrayI"))
    {
        [RootViewController extracted_method];
    }
    else if (style == objc_getClass("__NSArrayM"))
    {
        [RootViewController extracted_method];
    }
}

+(void)extracted_method
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"这里有数组越界" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
