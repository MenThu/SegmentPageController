//
//  HorizonPageCell.h
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableController.h"

@interface HorizonPageCell : UITableViewCell

@property (nonatomic, weak) NSArray <CommonTableController *> *controllerArray;
@property (nonatomic, copy) void (^changePage) (UIScrollView *listView);

@end
