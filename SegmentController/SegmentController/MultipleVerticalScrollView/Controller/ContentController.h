//
//  ContentController.h
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTableView.h"

@interface ContentController : UIViewController

/** 竖直滚动的内容视图 */
@property (nonatomic, weak) UIScrollView *contentScrollView;

/** 最底部的竖直滑动视图 */
@property (nonatomic, weak) UIScrollView *mainScrollView;

/** 最底部的竖直滑动视图的最大偏移量 */
@property (nonatomic, assign) CGFloat mainScrollViewMaxOffsetY;

/** 当contentScrollvewi发生滚动的时候，调用该方法 */
- (void)scrollViewScroll;

@end
