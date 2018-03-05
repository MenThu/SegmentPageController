//
//  ContentTableView.h
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableView : UITableView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isGestureDown;

@end
