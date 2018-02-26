//
//  ListController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ListController.h"
#import <MJRefresh/MJRefresh.h>

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
    if (targetOffset.y < self.maxOffset && targetOffset.y > self.minOffset) {
        CGFloat middleOffsetY = (self.maxOffset + self.minOffset)/2;
        if (targetOffset.y > middleOffsetY) {
            targetContentOffset->y = self.maxOffset;
        }else{
            targetContentOffset->y = self.minOffset;
        }
    }
}

//- (void)setScrollView:(UIScrollView *)scrollView{
//    _scrollView = scrollView;
//    UIPanGestureRecognizer *panGesture = scrollView.panGestureRecognizer;
//    NSMutableArray *targetArray = [panGesture valueForKey:@"_targets"];
////    NSLog(@"targetArray=[%@]", targetArray);
//    /** 拿到UIGestureRecognizerTarget(位于targetArray的第一个) */
//    id gestureRecognizerTarget = targetArray.firstObject;
//    /** 拿到UIGestureRecognizerTarget的target*/
//    id panGestureTarget = [gestureRecognizerTarget valueForKey:@"_target"];
//    /** 拿到UIGestureRecognizerTarget的方法*/
//    SEL handlePan = NSSelectorFromString(@"handlePan:");
//    Class _ScrollViewPanGesture = NSClassFromString(@"UIScrollViewPanGestureRecognizer");
//    self.scrollViewPanGesture = [[_ScrollViewPanGesture alloc] init];
//
////    unsigned int count = 0;
////    Ivar *var = class_copyIvarList(_ScrollViewPanGesture, &count);
////    for (NSInteger index = 0; index < count; index ++) {
////        Ivar _var = *(var+index);
////
////        const char *name = ivar_getName(_var);
////        NSString *propertyName = [NSString stringWithUTF8String:name];
////        NSLog(@"Encoding=[%s]", ivar_getTypeEncoding(_var));
////        NSLog(@"Name=[%@]", propertyName);
////        [self.scrollViewPanGesture setValue:[panGesture valueForKey:propertyName] forKey:propertyName];
////    }
//    self.scrollViewPanGesture.delaysTouchesBegan = YES;
//    self.scrollViewPanGesture.delegate = (id<UIGestureRecognizerDelegate>)scrollView;
//    [self.scrollViewPanGesture addTarget:panGestureTarget action:handlePan];
//}

@end
