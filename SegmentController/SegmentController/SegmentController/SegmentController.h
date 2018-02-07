//
//  SegmentController.h
//  BigTitleNavigationController
//
//  Created by MenThu on 2018/1/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentNaviBar.h"

@interface SegmentController : UIViewController

/**
 *  左右滑动的底视图
 */
@property (nonatomic, weak, readonly) UICollectionView *collectionView;

/**
 *  自定义的导航栏
 */
@property (nonatomic, weak, readonly) SegmentNaviBar *customNaviBar;

/**
 *  分栏列表页
 */
@property (nonatomic, strong) NSArray <UIScrollView *> *contentViewArray;

/**
 *  当前正在和用户交互的视图
 */
@property (nonatomic, weak) UIScrollView *currentContentView;

/**
 *  子类可以复写此方法，自定义NaviBar
 */
- (SegmentNaviBar *)customNaviBarInterface;

/**
 *  展示哪一页
 */
- (void)showPage:(NSInteger)page;

@end
