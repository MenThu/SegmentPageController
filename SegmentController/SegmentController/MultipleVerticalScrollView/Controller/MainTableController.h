//
//  MainTableController.h
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"

@interface MainTableController : UIViewController

@property (nonatomic, weak, readonly) UIScrollView *scrollView;

- (instancetype)initWith:(UIView *)headView
              headHeight:(CGFloat)headHeight
             segmentView:(UIView *)segmentView
           segmentHeight:(CGFloat)segmentHeight
       contentController:(NSArray <ContentController *> *)contentControllerArray;

- (void)userBeginTapOrDrag:(CGPoint)point;

@end
