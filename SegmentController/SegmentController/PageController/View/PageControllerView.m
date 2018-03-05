//
//  PageControllerView.m
//  SegmentController
//
//  Created by MenThu on 2018/2/10.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "PageControllerView.h"
#import "PageController.h"

@implementation PageControllerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (point.x <= 5) {
        return self;
    }
    PageController *pageController = (PageController *)self.nextResponder;
    [pageController hitPoint:point];
    return [super hitTest:point withEvent:event];
}

@end
