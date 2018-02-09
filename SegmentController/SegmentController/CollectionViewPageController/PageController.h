//
//  PageController.h
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListController.h"
#import "PageHeadView.h"

@interface PageController : UIViewController

@property (nonatomic, strong) NSArray <ListController *> *pageArray;
@property (nonatomic, weak) PageHeadView *headView;
/** 选择PageController的页数 */
- (void)pageViewScroll2Page:(NSInteger)page;

@end
