//
//  PageController.h
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListController.h"

@interface PageController : UIViewController

/**
 *  headView,头视图,可以为nil
 *  headViewHeight，头视图高度,若头视图为nil,方法会忽略此参数
 *  segmentView,停留在屏幕下方的组视图，可以为nil
 *  segmentHeight,组视图的高度,当segmentView为nil的时候,方法会忽略segmentHeight
 *  pageArray,内容视图的数组,控制器必须为ListController的子类
 */
- (instancetype)initWithHeadView:(UIView *)headView
                  headViewHeight:(CGFloat)headHeight
                     segmentView:(UIView *)segmentView
                   segmentHeight:(CGFloat)segmentHeight
                    pageArray:(NSArray <ListController *> *)pageArray;

@property (nonatomic, weak, readonly) UICollectionView *pageView;
@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, strong, readonly) UIView *wholeTopView;

/** 响应者链开始前 */
- (void)hitPoint:(CGPoint)point;
/** 选择PageController的页数 */
- (void)pageViewScroll2Page:(NSInteger)page;
/** 分页控制器滚动到了某一页 */
- (void)scroll2Page:(NSInteger)page;

@end
