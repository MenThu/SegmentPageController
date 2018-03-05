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
}

- (void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    scrollView.panGestureRecognizer.delaysTouchesBegan = YES;
    if (@available(iOS 11, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
}

@end
