//
//  URTabBarController.m
//  DIYTabBar
//
//  Created by Bin on 16/10/12.
//  Copyright © 2016年 urun. All rights reserved.
//

#import "URTabBarController.h"
#import "URTabBar.h"
#import <objc/runtime.h>

NSString *const URTabBarItemTitle = @"URTabBarItemTitle";
NSString *const URTabBarItemImage = @"URTabBarItemImage";
NSString *const URTabBarItemSelectedImage = @"URTabBarItemSelectedImage";

NSUInteger URTabBarItemsCount = 0;
CGFloat URTabBarItemWidth = 0.0f;
NSString *const URTabBarItemWidthDidChangeNotification = @"URTabBarItemWidthDidChangeNotification";

static void * const URSwappableImageViewDefaultOffsetContext = (void*)&URSwappableImageViewDefaultOffsetContext;

@interface NSObject (URTabBarControllerItemInternal)

- (void)setTabBarController:(URTabBarController *)tabBarController;

@end

@interface URTabBarController ()

@property (nonatomic, assign, getter=isObservingSwappableImageViewDefaultOffset) BOOL observingSwappableImageViewDefaultOffset;

@end

@implementation URTabBarController

@synthesize viewControllers = _viewControllers;

#pragma mark - Lift Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar addObserver:self
                  forKeyPath:@"swappableImageViewDefaultOffset"
                     options:NSKeyValueObservingOptionNew
                     context:URSwappableImageViewDefaultOffsetContext];
    
//    self.delegate = self;
    
}

- (void)viewWillLayoutSubviews
{
    if (!self.tabBarHeight)
    {
        return;
    }
    CGRect frame = self.tabBar.frame;
    CGFloat tabBarHeight = self.tabBarHeight;
    frame.size.height = tabBarHeight;
    frame.origin.y = self.view.frame.size.height - tabBarHeight;
    self.tabBar.frame = frame;
}

- (void)dealloc
{
    if (self.isObservingSwappableImageViewDefaultOffset)
    {
        [self.tabBar removeObserver:self forKeyPath:@"swappableImageViewDefaultOffset"];
    }
}

#pragma mark - public methods

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
{
    if (self = [super init])
    {
        _tabBarItemsAttributes = tabBarItemsAttributes;
        self.viewControllers = viewControllers;
    }
    return self;
}

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
{
    URTabBarController *tabBarController = [[URTabBarController alloc] initWithViewControllers:viewControllers tabBarItemsAttributes:tabBarItemsAttributes];
    return tabBarController;
}

+ (NSUInteger)allItemInTabBarCount
{
    NSUInteger allItemsInTabBar = URTabBarItemsCount;
    return allItemsInTabBar;
}


- (id<UIApplicationDelegate>)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow
{
    UIWindow *result = nil;
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)])
        {
            result = [self.appDelegate window];
        }
        if (result)
        {
            break;
        }
    } while (NO);
    
    return result;
}

#pragma mark - private methods

- (void)setUpTabBar
{
    [self setValue:[[URTabBar alloc] init] forKey:@"tabBar"];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    if (_viewControllers && _viewControllers.count)
    {
        for (UIViewController *viewController in _viewControllers)
        {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]])
    {
        if ((!_tabBarItemsAttributes) || (_tabBarItemsAttributes.count != viewControllers.count)) {
            [NSException raise:@"CYLTabBarController" format:@"The count of CYLTabBarControllers is not equal to the count of tabBarItemsAttributes.【Chinese】设置_tabBarItemsAttributes属性时，请确保元素个数与控制器的个数相同，并在方法`-setViewControllers:`之前设置"];
        }
        
        _viewControllers = [viewControllers copy];
        
        URTabBarItemsCount = [viewControllers count];
        URTabBarItemWidth = [UIScreen mainScreen].bounds.size.width / (URTabBarItemsCount);
        
        NSUInteger idx = 0;
        for (UIViewController *viewController in _viewControllers)
        {
            NSString *title = nil;
            NSString *normalImageName = nil;
            NSString *selectedImageName = nil;
            title = _tabBarItemsAttributes[idx][URTabBarItemTitle];
            normalImageName = _tabBarItemsAttributes[idx][URTabBarItemImage];
            selectedImageName = _tabBarItemsAttributes[idx][URTabBarItemSelectedImage];
            idx++;
            
            [self addOneChildViewController:viewController
                                  WithTitle:title
                            normalImageName:normalImageName
                          selectedImageName:selectedImageName];
        }
    }
    else
    {
        for (UIViewController *viewcController in _viewControllers)
        {
            [viewcController setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

- (void)addOneChildViewController:(UIViewController *)viewController
                        WithTitle:(NSString *)title
                  normalImageName:(NSString *)normalImageName
                selectedImageName:(NSString *)selectedImageName
{
    viewController.tabBarItem.title = title;
    if (normalImageName)
    {
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 渲染模式
        viewController.tabBarItem.image = normalImage;
    }
    if (selectedImageName)
    {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 渲染模式
        viewController.tabBarItem.image = selectedImage;
    }
    if (self.shouldCustomizeImageInsets)
    {
        viewController.tabBarItem.imageInsets = self.imageInsets;
    }
    if (self.shouldCustomizeTitlePositionAdjustment)
    {
        viewController.tabBarItem.titlePositionAdjustment = self.titlePositionAdjustment;
    }
    [self addChildViewController:viewController];
}

- (BOOL)shouldCustomizeImageInsets {
    BOOL shouldCustomizeImageInsets = self.imageInsets.top != 0.f || self.imageInsets.left != 0.f || self.imageInsets.bottom != 0.f || self.imageInsets.right != 0.f;
    return shouldCustomizeImageInsets;
}

- (BOOL)shouldCustomizeTitlePositionAdjustment {
    BOOL shouldCustomizeTitlePositionAdjustment = self.titlePositionAdjustment.horizontal != 0.f || self.titlePositionAdjustment.vertical != 0.f;
    return shouldCustomizeTitlePositionAdjustment;
}

#pragma mark - KVO methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != URSwappableImageViewDefaultOffsetContext)
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if (context == URSwappableImageViewDefaultOffsetContext)
    {
        CGFloat swappableImageViewDefaultOffset = [change[NSKeyValueChangeNewKey] floatValue];
        [self offsetTabBarSwappableImageViewToFit:swappableImageViewDefaultOffset];
    }
}

- (void)offsetTabBarSwappableImageViewToFit:(CGFloat)swappableImageViewDefaultOffset
{
    if (self.shouldCustomizeImageInsets)
    {
        return;
    }
    NSArray<UITabBarItem *> *tabBarItems = [self tabBarController].tabBar.items;
    [tabBarItems enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIEdgeInsets imageInset = UIEdgeInsetsMake(swappableImageViewDefaultOffset, 0, -swappableImageViewDefaultOffset, 0);
        obj.imageInsets = imageInset;
        if (!self.shouldCustomizeTitlePositionAdjustment)
        {
            obj.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
        }
    }];
}

#pragma mark - delegate

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    NSUInteger selectedIndex = tabBarController.selectedIndex;
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma mark - NSObject+URTabBarControllerItem

@implementation NSObject (URTabBarControllerItemInternal)

- (void)setTabBarController:(URTabBarController *)tabBarController
{
    objc_setAssociatedObject(self, @selector(ur_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation NSObject (URTabBarController)

- (URTabBarController *)ur_tabBarController
{
    URTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(ur_tabBarController));
    if (tabBarController)
    {
        return tabBarController;
    }
    if ([self isKindOfClass:[UIViewController class]] && [(UIViewController *)self parentViewController])
    {
        tabBarController = [[(UIViewController *)self parentViewController] ur_tabBarController];
        return tabBarController;
    }
    
    id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
    UIWindow *window = delegate.window;
    if ([window.rootViewController isKindOfClass:[URTabBarController class]])
    {
        tabBarController = (URTabBarController *)window.rootViewController;
    }
    return tabBarController;
}

@end




