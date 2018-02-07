//
//  SegmentControllerView.m
//  BigTitleNavigationController
//
//  Created by MenThu on 2018/1/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SegmentControllerView.h"

@implementation SegmentControllerView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    NSLog(@"hitView=[%@][%p]", NSStringFromClass([hitView class]), hitView);
//    if (hitView == self.controller.customNaviBar) {
//        return self.controller.currentContentView;
//    }else if ([hitView isDescendantOfView:self.controller.customNaviBar]){
//        if ([self.controller.customNaviBar allowHitView:hitView]) {
//            return hitView;
//        }else{
//            return self.controller.currentContentView;
//        }
//    }else{
//        return hitView;
//    }
//}

@end
