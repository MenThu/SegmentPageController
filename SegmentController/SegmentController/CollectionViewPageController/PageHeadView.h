//
//  PageHeadView.h
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageHeadView : UIView

/** 手指在视图的平移的距离 */
@property (nonatomic, copy) void (^panBlock) (BOOL isEnd, CGFloat yMoveLength);

- (CGFloat)getMaxHeight;
- (CGFloat)getMinHeight;

@end
