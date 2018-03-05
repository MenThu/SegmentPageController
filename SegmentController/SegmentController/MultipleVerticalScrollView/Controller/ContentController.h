//
//  ContentController.h
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentTableView.h"

@interface ContentController : UIViewController

@property (nonatomic, weak, readonly) ContentTableView *tableView;
- (void)sendScrollNotification;

@end
