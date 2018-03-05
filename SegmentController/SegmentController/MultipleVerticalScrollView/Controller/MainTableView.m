//
//  MainTableView.m
//  SegmentController
//
//  Created by MenThu on 2018/3/5.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainTableView.h"
#import "MainTableController.h"

@interface MainTableView ()

@property (nonatomic, weak) MainTableController *mainController;

@end

@implementation MainTableView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    self.isPanGestureBegin = NO;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        if ([panGesture velocityInView:self].y > 0) {
            self.isPanGestureBegin = [self.mainController canDragDown];
        }
        self.isPanGestureBegin = YES;
    }else{
        self.isPanGestureBegin = NO;
    }
    return self.isPanGestureBegin;
}

- (MainTableController *)mainController{
    if (_mainController == nil) {
        UIResponder *responder = self.nextResponder;
        while (responder) {
            if ([responder isKindOfClass:[MainTableController class]]) {
                _mainController = (MainTableController *)responder;
                break;
            }
            responder = responder.nextResponder;
        }
    }
    return _mainController;
}

@end
