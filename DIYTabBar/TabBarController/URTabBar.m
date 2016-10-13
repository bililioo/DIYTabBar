//
//  URTabBar.m
//  DIYTabBar
//
//  Created by Bin on 16/10/12.
//  Copyright © 2016年 urun. All rights reserved.
//

#import "URTabBar.h"
#import "URTabBarController.h"

static void *const URTabBarContext = (void *)&URTabBarContext;

@interface URTabBar ()

@property (nonatomic, assign) CGFloat tabBarItemWidth;

@property (nonatomic, copy) NSArray *tabBarButtonArray;

@end

@implementation URTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [self shareInit];
    }
    return self;
}

- (instancetype)shareInit
{
    _tabBarItemWidth = URTabBarItemWidth;
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:URTabBarContext];
    
    return self;
}

- (NSArray *)tabBarButtonArray
{
    if (!_tabBarButtonArray)
    {
        _tabBarButtonArray = [[NSArray alloc] init];
    }
    return _tabBarButtonArray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat barWidth = self.bounds.size.width;
    CGFloat barHeight = self.bounds.size.height;
    
    URTabBarItemWidth = barWidth / URTabBarItemsCount;
    self.tabBarItemWidth = URTabBarItemWidth;
    
    NSArray *sortedSubviews = [self sortedSubviews];
}


/*!
 *  Deal with some trickiness by Apple, You do not need to understand this method, somehow, it works.
 *  NOTE: If the `self.title of ViewController` and `the correct title of tabBarItemsAttributes` are different, Apple will delete the correct tabBarItem from subViews, and then trigger `-layoutSubviews`, therefore subViews will be in disorder. So we need to rearrange them.
 */
- (NSArray *)sortedSubviews
{
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
        CGFloat formerViewX = formerView.frame.origin.x;
        CGFloat latterViewX = latterView.frame.origin.x;
        return  (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
    }];
    return sortedSubviews;
}

@end














