//
//  HitTestView.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "HitTestView.h"

@implementation HitTestView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSString *selector = [NSString stringWithFormat:@"%s", sel_getName(_cmd)];
    UIView *testView = [super hitTest:point withEvent:event];
    if ([testView isKindOfClass:[HitTestView class]]) {
        HitTestView *tempView = (HitTestView *)testView;
        NSLog(@"[%@] [%@] [%@]", selector, self.viewName, tempView.viewName);
    }else{
        if (testView == nil) {
            NSLog(@"[%@] [%@] [nil]", selector, self.viewName);
        }else{
            NSLog(@"[%@] [%@] [%p]", selector, self.viewName, testView);
        }
    }
    return testView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSString *selector = [NSString stringWithFormat:@"%s", sel_getName(_cmd)];
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"[%@] [%@] [%@]", selector, self.viewName, isInside ? @"命中" : @"未命中");
    return isInside;
}

@end
