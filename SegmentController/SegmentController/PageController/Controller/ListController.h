//
//  ListController.h
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const SubScrollViewDidScroll;

@interface ListController : UIViewController <UIScrollViewDelegate>

/** 列表页，需要子类赋值,可以是tableView也可是collectionView */
@property (nonatomic, weak) UIScrollView *scrollView;

@end
