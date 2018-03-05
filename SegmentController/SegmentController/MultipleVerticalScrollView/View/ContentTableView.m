//
//  ContentTableView.m
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ContentTableView.h"
#import "MainTableController.h"

@interface ContentTableView ()

@property (nonatomic, weak) UITableView *mainTableView;

@end

@implementation ContentTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    UIView *otherView = otherGestureRecognizer.view;
    self.isGestureDown = NO;
    if (otherView == self.mainTableView) {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
            CGFloat yVelCity = [panGesture velocityInView:self].y;
            if (yVelCity > 0) {
                if (self.contentOffset.y > 0) {
                    NSLog(@"向下拖拽=[不传递]");
                    self.isGestureDown = NO;
                }else{
                    NSLog(@"向下拖拽=[传递]");
                    self.isGestureDown = YES;
                }
            }else{
                NSLog(@"向上拖拽=[传递]");
                self.isGestureDown = YES;
            }
        }
    }else{
        self.isGestureDown = NO;
    }
    return self.isGestureDown;
}

- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        UIResponder *responder = self.nextResponder;
        while (responder) {
            if ([responder isKindOfClass:[MainTableController class]]) {
                MainTableController *controller = (MainTableController *)responder;
                _mainTableView = controller.tableView;
                break;
            }
            responder = responder.nextResponder;
        }
    }
    return _mainTableView;
}

@end
