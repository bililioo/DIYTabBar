//
//  URTabBarController.m
//  DIYTabBar
//
//  Created by Bin on 16/10/12.
//  Copyright © 2016年 urun. All rights reserved.
//

#import "URTabBarController.h"

static void * const URSwappableImageViewDefaultOffsetContext = (void*)&URSwappableImageViewDefaultOffsetContext;

@interface NSObject (URTabBarControllerItemInternal)

- (void)setTabBarController:(URTabBarController *)tabBarController;

@end

@interface URTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, assign, getter=isObservingSwappableImageViewDefaultOffset) BOOL observingSwappableImageViewDefaultOffset;

@end

@implementation URTabBarController

#pragma mark - Lift Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar addObserver:self
                  forKeyPath:@"swappableImageViewDefaultOffset"
                     options:NSKeyValueObservingOptionNew
                     context:URSwappableImageViewDefaultOffsetContext];
    
    self.delegate = self;
    
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
