//
//  UIViewController+URTabBarControllerExtention.h
//  DIYTabBar
//
//  Created by Bin on 16/10/13.
//  Copyright © 2016年 urun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^URPopSelectTabBarChildViewControllerCompletion)(__kindof UIViewController *selectedTabBarChildViewController);

@interface UIViewController (URTabBarControllerExtention)

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param index 需要选择的控制器在 `TabBar` 中的 index。
 @return 最终被选择的控制器。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (UIViewController *)ur_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 @param index 需要选择的控制器在 `TabBar` 中的 index。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (void)ur_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(URPopSelectTabBarChildViewControllerCompletion)completion;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param classType 需要选择的控制器所属的类。
 @return 最终被选择的控制器。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (UIViewController *)ur_popSelectTabBarChildViewControllerForClassType:(Class)classType;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 @param classType 需要选择的控制器所属的类。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (void)ur_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(URPopSelectTabBarChildViewControllerCompletion)completion;

@end
