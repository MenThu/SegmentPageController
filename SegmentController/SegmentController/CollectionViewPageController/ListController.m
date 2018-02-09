//
//  ListController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ListController.h"

NSString * const SubScrollViewDidScroll = @"SubScrollViewDidScroll";

@interface ListController ()

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
}

- (void)sendScrollNotification{
    NSAssert(self.scrollView != nil, @"scrollView不能为空");
    [[NSNotificationCenter defaultCenter] postNotificationName:SubScrollViewDidScroll object:self.scrollView];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
//    NSLog(@"targetOffset=[%@],Veloticy=[%@]", NSStringFromCGPoint(targetOffset), NSStringFromCGPoint(velocity));
    if (targetOffset.y < self.maxOffset && targetOffset.y > self.minOffset) {
        CGFloat middleOffsetY = (self.maxOffset + self.minOffset)/2;
        if (targetOffset.y > middleOffsetY) {
            targetContentOffset->y = self.maxOffset;
        }else{
            targetContentOffset->y = self.minOffset;
        }
    }
}

@end
