//
//  TabBarControllerConfig.m
//  DIYTabBar
//
//  Created by Bin on 16/10/14.
//  Copyright © 2016年 urun. All rights reserved.
//

#import "TabBarControllerConfig.h"
@import Foundation;
@import UIKit;

@interface URBaseNavigationController : UINavigationController

@end

@implementation URBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

@implementation TabBarControllerConfig

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (URTabBarController *)tabBarController
{
    if (!_tabBarController)
    {
        _tabBarController = [URTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                              tabBarItemsAttributes:self.tabBarItemsAttributes];
        [self customizeTabBarAppearance:_tabBarController];
    }
    return _tabBarController;
}

- (NSArray *)viewControllers
{
    OneViewController *oneVC = [[OneViewController alloc] init];
    URBaseNavigationController *oneNav = [[URBaseNavigationController alloc] initWithRootViewController:oneVC];
    
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    URBaseNavigationController *twoNav = [[URBaseNavigationController alloc] initWithRootViewController:twoVC];
    
    TwoViewController *threeVC = [[TwoViewController alloc] init];
    URBaseNavigationController *threeNav = [[URBaseNavigationController alloc] initWithRootViewController:threeVC];
    
    NSArray *viewControllers = @[oneNav,
                                 twoNav,
                                 threeNav,
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributes
{
    NSDictionary *oneAttribute = @{
                                   URTabBarItemTitle : @"消息",
                                   URTabBarItemImage : @"home_normal",
                                   URTabBarItemSelectedImage : @"home_highlight",
                                   };
    NSDictionary *twoAttribute = @{
                                   URTabBarItemTitle : @"消息2",
                                   URTabBarItemImage : @"home_normal",
                                   URTabBarItemSelectedImage : @"home_highlight",
                                   };
    NSDictionary *threeAttribute = @{
                                   URTabBarItemTitle : @"消息3",
                                   URTabBarItemImage : @"home_normal",
                                   URTabBarItemSelectedImage : @"home_highlight",
                                   };
    
    NSArray *tabBarItemsAttributes = @[
                                       oneAttribute,
                                       twoAttribute,
                                       threeAttribute,
                                       ];
    return tabBarItemsAttributes;
}

- (void)customizeTabBarAppearance:(URTabBarController *)tabBarController {
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height
    // 自定义 TabBar 高度
    tabBarController.tabBarHeight = 40.f;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}


@end
