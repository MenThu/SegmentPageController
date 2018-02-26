//
//  CommonTableController.h
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipleTable.h"

UIKIT_EXTERN NSString *const CommonTableScroll;

@interface CommonTableController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) MultipleTable *tableView;

@end
