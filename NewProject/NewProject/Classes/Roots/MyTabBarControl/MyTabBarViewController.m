//
//  MyTabBarViewController.m
//  NewProject
//
//  Created by huangliru on 2017/7/26.
//  Copyright © 2017年 huangliru. All rights reserved.
//

#import "MyTabBarViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
/*
 * 初始化ViewControllers
 */
-(void)initViewControllers
{
    
}
/**
 创建个人tabbar标签
 */
-(void)createPersonageTabBarItems
{
    NSArray *selectAray = @[@"icon_shouye_h.png",@"icon_sousuo_h.png",@"icon_xiaoxi_h.png",@"icon_me_h.png"];
    NSArray *unSelectArray = @[@"icon_shouye_n.png",@"icon_sousuo_n.png",@"icon_xiaoxi_n.png",@"icon_me_n.png"];
    NSArray *titltArray = @[@"首页",@"搜索",@"消息",@"我的"];
    NSArray *allItems = self.tabBar.items;
    for (int i = 0; i<allItems.count; i++)
    {
        //设置每个item的属性
        UITabBarItem *item = allItems[i];
        
        UIImage *selectImage = [self loadImageName:selectAray[i]];
        UIImage *unSelectImage = [self loadImageName:unSelectArray[i]];
        item = [item initWithTitle:titltArray[i] image:unSelectImage selectedImage:selectImage];
        NSLog(@"%@",item);
    }
    
    self.tabBar.backgroundImage = [self loadImageName:@"tabbar_bg.png"];
    //消除阴影线
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    //设置文字的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:130/225.0 green:130/225.0 blue:130/225.0 alpha:1.0]} forState:UIControlStateNormal];
}
//封装方法
-(UIImage *)loadImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",name]];
    //在ios7下需要对图片进行处理，否则会是阴影，不是远图像
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
    
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
