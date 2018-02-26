//
//  MainScrollController.h
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableController.h"

@interface MainScrollController : UIViewController

/**
 *  tableHeadView 头视图,可以为nil
 *  headHeight 头视图高度,(若头视图为nil，则内部会忽略此参数)
 *  sectionView 组视图,可以为nil
 *  sectionHeight 组视图高度,(若头视图为nil，则内部会忽略此参数)
 *  内容视图控制器 必须为CommonTableController的子类
 */
- (instancetype)initWithTableHeadView:(UIView *)tableHeadView
                       headHeight:(CGFloat)headHeight
                      sectionView:(UIView *)sectionView
                    sectionHeight:(CGFloat)sectionHeight
            contentControlerArray:(NSArray <CommonTableController *> *)controllerArray;

@end
