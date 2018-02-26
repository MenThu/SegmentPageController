//
//  ListController.h
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const SubScrollViewDidScroll;

@interface ListController : UIViewController <UIScrollViewDelegate>

/** 列表页，需要子类赋值,可以是tableView也可是collectionView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 一个用于作用到scrollView的拖动手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *scrollViewPanGesture;
/** 最大偏移量 */
@property (nonatomic, assign) CGFloat maxOffset;
/** 最小偏移量 */
@property (nonatomic, assign) CGFloat minOffset;

/** 子类滚动视图发生滑动时，需要调用此方法 */
- (void)sendScrollNotification;

@end
