//
//  MainTableCell.h
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentController.h"

@interface MainTableCell : UITableViewCell

@property (nonatomic, weak) NSArray <ContentController *> *contentControllerArray;
@property (nonatomic, copy) void (^changePage) (NSInteger currentPage);

@end
