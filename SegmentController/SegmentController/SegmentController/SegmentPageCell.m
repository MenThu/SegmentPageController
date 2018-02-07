//
//  SegmentPageCell.m
//  BigTitleNavigationController
//
//  Created by MenThu on 2018/1/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SegmentPageCell.h"

@implementation SegmentPageCell

- (void)setSubContentView:(UIView *)subContentView{
    if ([subContentView isKindOfClass:[UIView class]]) {
        [_subContentView removeFromSuperview];
        subContentView.frame = self.contentView.bounds;
        [self.contentView addSubview:(_subContentView = subContentView)];
    }
}

@end
