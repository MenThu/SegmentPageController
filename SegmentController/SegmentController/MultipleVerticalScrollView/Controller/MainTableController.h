//
//  MainTableController.h
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"
#import "MainTableView.h"

@interface MainTableController : UIViewController

@property (nonatomic, weak, readonly) MainTableView *tableView;

- (BOOL)canDragDown;

- (instancetype)initWith:(UIView *)headView
              headHeight:(CGFloat)headHeight
             segmentView:(UIView *)segmentView
           segmentHeight:(CGFloat)segmentHeight
       contentController:(NSArray <ContentController *> *)contentControllerArray;

@end
