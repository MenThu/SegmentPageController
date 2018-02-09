//
//  PageCell.m
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "PageCell.h"

@implementation PageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView{
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setChildControllerView:(UIView *)childControllerView{
    if (_childControllerView != nil) {
        [_childControllerView removeFromSuperview];
    }
    if ([childControllerView.superview isKindOfClass:[UIView class]]) {
        [childControllerView removeFromSuperview];
    }
    [self.contentView addSubview:(_childControllerView = childControllerView)];
    _childControllerView.frame = self.contentView.bounds;
}

@end
