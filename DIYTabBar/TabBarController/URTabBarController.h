//
//  URTabBarController.h
//  DIYTabBar
//
//  Created by Bin on 16/10/12.
//  Copyright © 2016年 urun. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const URTabBarItemTitle;
FOUNDATION_EXTERN NSString *const URTabBarItemImage;
FOUNDATION_EXTERN NSString *const URTabBarItemSelectImage;
FOUNDATION_EXTERN NSUInteger URTabBarItemsCount;
//FOUNDATION_EXTERN NSUInteger URPl
FOUNDATION_EXTERN CGFloat URTabBarItemWidth;

@interface URTabBarController : UITabBarController

@property (nonatomic, readwrite, copy) NSArray<UIViewController *> *viewControllers;

@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> *tabBarItemAttriButes;

@property (nonatomic, assign) CGFloat tabBarHeight;

@property (nonatomic, readwrite, assign) UIEdgeInsets imageInsets;

@property (nonatomic, readwrite, assign) UIOffset titlePositionAdjustment;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;


@end
