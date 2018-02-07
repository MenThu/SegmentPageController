//
//  SegmentNaviBar.h
//  BigTitleNavigationController
//
//  Created by MenThu on 2018/1/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const NAVIBAR_HEIGHT = 44.f;

@interface SegmentNaviBar : UIView

/**
 *  状态栏高度
 */
@property (nonatomic, assign, readonly) CGFloat statusBarHeight;

/**
 *  标题，不能为nil
 */
@property (nonatomic, strong) NSString *naviTitle;

/**
 *  左侧视图，可以为nil
 *  动效: alpha从0-1
 */
@property (nonatomic, weak) UIView *leftView;

/**
 *  右侧视图,可以为nil
 *  动效: 从titleLabel竖直居中
 */
@property (nonatomic, weak) UIView *rightView;

/**
 *  标题Label
 */
@property (nonatomic, weak, readonly)  UILabel *titleLabel;

/**
 *  自定义Navibar的正常高度，默认为64(iPhoneX为88)
 *  子类可以自定义
 */
@property (nonatomic, assign) CGFloat normalHeight;

/**
 *  最大高度，也是初始化高度
 *  默认为150
 *  子类可以自定义
 */
@property (nonatomic, assign) CGFloat maxHeight;

/**
 *  最大偏移量
 */
@property (nonatomic, assign) CGFloat maxOffset;

/**
 *  配置子视图入口
 */
- (void)configView;

/**
 *  更改控件Frame的入口，复写前首先调用[super frameChangeWithPercent];
 */
- (void)frameChangeWithPercent:(CGFloat)percent;

/**
 *  更改titleLabel的frame，子类可以复写
 */
- (void)changeTitle:(CGFloat)percent;

/**
 *  是否允许hitView接受事件
 */
- (BOOL)allowHitView:(UIView *)hitView;

@end
