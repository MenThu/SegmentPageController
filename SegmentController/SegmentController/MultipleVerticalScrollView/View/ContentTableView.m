//
//  ContentTableView.m
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ContentTableView.h"
#import "MainTableController.h"

@interface ContentTableView ()

@property (nonatomic, weak) UITableView *mainTableView;

@end

@implementation ContentTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    UIView *otherView = otherGestureRecognizer.view;
    if ([otherView isKindOfClass:[UICollectionView class]]) {
        return NO;
    }else{
        return YES;
    }
}

@end
