//
//  MainControllerView.m
//  SegmentController
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainControllerView.h"
#import "MainTableController.h"

@interface MainControllerView ()

@property (nonatomic, weak) MainTableController *mainController;

@end

@implementation MainControllerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    [self.mainController userBeginTapOrDrag:point];
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView;
}

- (MainTableController *)mainController{
    if (_mainController == nil) {
        UIResponder *responder = self.nextResponder;
        while (responder != nil) {
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
