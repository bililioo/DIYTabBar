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
//    CGFloat barHeight = self.bounds.size.height;
    
    URTabBarItemWidth = barWidth / URTabBarItemsCount;
    self.tabBarItemWidth = URTabBarItemWidth;
    
    NSArray *sortedSubviews = [self sortedSubviews];
    self.tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
    [self setupSwappableImageViewDefaultOffset:self.tabBarButtonArray[0]];
    
    [self.tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
            childViewX = buttonIndex * URTabBarItemWidth;
        //仅修改childView的x和宽度,yh值不变
        childView.frame = CGRectMake(childViewX,
                                     CGRectGetMinY(childView.frame),
                                     URTabBarItemWidth,
                                     CGRectGetHeight(childView.frame)
                                     );
    }];

}

#pragma mark - Private Methods

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    return NO;
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != URTabBarContext)
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if (context == URTabBarContext)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:URTabBarItemWidthDidChangeNotification object:self];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}

- (void)setTabBarItemWidth:(CGFloat)tabBarItemWidth
{
    if (_tabBarItemWidth != tabBarItemWidth)
    {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

- (void)setSwappableImageViewDefaultOffset:(CGFloat)swappableImageViewDefaultOffset
{
    if (swappableImageViewDefaultOffset != 0.f)
    {
        [self willChangeValueForKey:@"swappableImageViewDefaultOffset"];
        _swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
        [self didChangeValueForKey:@"swappableImageViewDefaultOffset"];
    }
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

- (NSArray *)tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews
{
    NSMutableArray *tabBarBtnMuArr = [NSMutableArray arrayWithCapacity:tabBarSubviews.count - 1];
    [tabBarSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [tabBarBtnMuArr addObject:obj];
        }
    }];
    return [tabBarBtnMuArr copy];
}

- (void)setupSwappableImageViewDefaultOffset:(UIView *)tabBarButton
{
    __block BOOL shouldCustomizeImageView = YES;
    __block CGFloat swappableImageViewHeight = 0.f;
    __block CGFloat swappableImageViewDefaultOffset = 0.f;
    __block CGFloat offset = 0.f;
    
    CGFloat tabBarHeight = self.frame.size.height;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")])
        {
            shouldCustomizeImageView = NO;
        }
        offset = obj.frame.size.height;
        BOOL isSwappableImageView = [obj isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")];
        if (isSwappableImageView)
        {
            swappableImageViewDefaultOffset = (tabBarHeight - swappableImageViewHeight) * 0.5 * 0.5;
        }
        if (isSwappableImageView && swappableImageViewDefaultOffset == 0.f)
        {
            shouldCustomizeImageView = NO;
        }
    }];
    
    if (shouldCustomizeImageView)
    {
        self.swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
    }
    
}

/*!
 *  Capturing touches on a subview outside the frame of its superview.
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL canNotResponseEvent = self.hidden || (self.alpha <= 0.01f) || (self.userInteractionEnabled == NO);
    if (canNotResponseEvent) {
        return nil;
    }

    NSArray *tabBarButtons = self.tabBarButtonArray;
    if (self.tabBarButtonArray.count == 0) {
        tabBarButtons = [self tabBarButtonFromTabBarSubviews:self.subviews];
    }
    for (NSUInteger index = 0; index < tabBarButtons.count; index++) {
        UIView *selectedTabBarButton = tabBarButtons[index];
        CGRect selectedTabBarButtonFrame = selectedTabBarButton.frame;
        if (CGRectContainsPoint(selectedTabBarButtonFrame, point)) {
            return selectedTabBarButton;
        }
    }
    return nil;
}



@end

































