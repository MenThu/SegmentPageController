//
//  MPHomePageNaviBar.m
//  BigTitleNavigationController
//
//  Created by MenThu on 2018/1/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SegmentNaviBar.h"

@interface SegmentNaviBar ()

@property (nonatomic, assign, readwrite) CGFloat statusBarHeight;

@property (nonatomic, weak, readwrite)   UILabel *titleLabel;
@property (nonatomic, assign) CGSize  bigSize;
@property (nonatomic, assign) CGSize  normalSize;
@property (nonatomic, assign) CGFloat bigBottomSpace;
@property (nonatomic, assign) CGFloat normalBottomSpace;
@property (nonatomic, assign) CGFloat bigLeftSpace;
@property (nonatomic, assign) CGFloat normalLeftSpace;
@property (nonatomic, assign) CGFloat bigFont;
@property (nonatomic, assign) CGFloat normalFont;

@property (nonatomic, assign) CGFloat bigLeftViewLeftSpace;
@property (nonatomic, assign) CGFloat normalLeftViewLeftSpace;
@property (nonatomic, assign) CGSize  leftViewSize;

@property (nonatomic, assign) CGFloat bigRightViewRightSpace;
@property (nonatomic, assign) CGFloat normalRightViewRightSpace;
@property (nonatomic, assign) CGSize rightViewSize;
@property (nonatomic, assign) CGFloat currentPercent;

@end

@implementation SegmentNaviBar

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    self.maxHeight = 150.f;
    CGFloat temp = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    if (temp == 44) {
        //iPhoneX
        self.normalHeight = 88;
    }else{
        //其他机型
        self.normalHeight = 64;
    }
    self.statusBarHeight = temp;
    self.maxOffset = self.maxHeight - self.normalHeight;
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    self.bigFont = 30;
    self.normalFont = 18.f;
    titleLabel.font = [UIFont systemFontOfSize:self.bigFont];
    [self addSubview:(_titleLabel = titleLabel)];
    
    self.bigLeftViewLeftSpace = self.normalLeftViewLeftSpace = 10.f;
    self.bigRightViewRightSpace = 10;
    self.normalRightViewRightSpace = 10;
    self.currentPercent = 0;
}

- (void)changeTitle:(CGFloat)percent{
    CGFloat temp = (self.bigLeftSpace - self.normalLeftSpace)*percent;
    CGFloat currentLeftSpace = self.bigLeftSpace - temp;
    
    temp = (self.bigBottomSpace - self.normalBottomSpace)*percent;
    CGFloat currentBottomSpce = self.bigBottomSpace - temp;
    
    temp = (self.bigSize.width - self.normalSize.width)*percent;
    CGFloat currentWidth = self.bigSize.width - temp;
    
    temp = (self.bigSize.height - self.normalSize.height)*percent;
    CGFloat currentHeight = self.bigSize.height - temp;
    
    temp = (self.bigFont - self.normalFont)*percent;
    CGFloat currentFont = self.bigFont - temp;
    
    self.titleLabel.frame = CGRectMake(currentLeftSpace, self.bounds.size.height-currentBottomSpce-currentHeight, currentWidth, currentHeight);
    self.titleLabel.font = [UIFont systemFontOfSize:currentFont];
}

- (void)changeLeftView:(CGFloat)percent{
    if (self.leftView != nil) {
        CGFloat temp = (self.bigLeftViewLeftSpace - self.normalLeftViewLeftSpace)*percent;
        CGFloat currentLeftSpace = self.bigLeftViewLeftSpace - temp;
        self.leftView.frame = CGRectMake(currentLeftSpace, self.leftView.frame.origin.y, self.leftViewSize.width, self.leftViewSize.height);
        self.leftView.alpha = percent;
    }
}

- (void)changeRightView:(CGFloat)percent{
    if (self.rightView != nil) {
        CGFloat temp = (self.bigRightViewRightSpace - self.normalRightViewRightSpace)*percent;
        CGFloat x = self.bounds.size.width - (self.bigRightViewRightSpace - temp) - self.rightViewSize.width;
        CGFloat y = CGRectGetMidY(self.titleLabel.frame) - self.rightViewSize.height/2;
        self.rightView.frame = CGRectMake(x, y, self.rightViewSize.width, self.rightViewSize.height);
    }    
}

- (void)frameChangeWithPercent:(CGFloat)percent{
    [self changeTitle:percent];
    [self changeLeftView:percent];
    [self changeRightView:percent];
}

- (BOOL)allowHitView:(UIView *)hitView{
    if (hitView == self.leftView || hitView == self.rightView) {
        return YES;
    }
    return NO;
}

#pragma mark - Setter
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        return;
    }
    CGFloat percent = 1 - (CGRectGetHeight(self.frame) - self.normalHeight)/self.maxOffset;
    if (percent == self.currentPercent) {
        return;
    }
    self.currentPercent = percent;
    [self frameChangeWithPercent:self.currentPercent];
}

- (void)setNaviTitle:(NSString *)naviTitle{
    self.titleLabel.text = naviTitle;
    //计算初始Frame和最终的Frame
    CGFloat originWidth = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.titleLabel.font.lineHeight)].width;
    CGFloat temp = 1.3;
    self.bigSize = CGSizeMake(originWidth, self.titleLabel.font.lineHeight);
    self.normalSize = CGSizeMake(originWidth/temp, self.titleLabel.font.lineHeight/temp);
    self.bigBottomSpace = 10.f;
    self.normalBottomSpace = NAVIBAR_HEIGHT/2 - self.normalSize.height/2;
    self.bigLeftSpace = 15;
    self.normalLeftSpace = self.bounds.size.width/2 - self.normalSize.width/2;
    self.titleLabel.frame = CGRectMake(self.bigLeftSpace, self.bounds.size.height-self.bigBottomSpace-self.bigSize.height, self.bigSize.width, self.bigSize.height);
}

- (void)setLeftView:(UIView *)leftView{
    if (_leftView != nil) {
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    if (![leftView isKindOfClass:[UIView class]]) {
        return;
    }
    [self addSubview:(_leftView = leftView)];
    self.leftViewSize = leftView.bounds.size;
    self.leftView.alpha = 0;
    CGFloat y = self.statusBarHeight + NAVIBAR_HEIGHT/2 - self.leftViewSize.height/2;
    self.leftView.frame = CGRectMake(self.bigLeftViewLeftSpace, y, self.leftViewSize.width, self.leftViewSize.height);
}

- (void)setRightView:(UIView *)rightView{
    if (_rightView != nil) {
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    if (![rightView isKindOfClass:[UIView class]]) {
        return;
    }
    [self addSubview:(_rightView = rightView)];
    self.rightViewSize = rightView.bounds.size;
    CGFloat y = CGRectGetMaxY(self.titleLabel.frame) - CGRectGetHeight(self.titleLabel.frame)/2 - self.rightViewSize.height/2;
    self.rightView.frame = CGRectMake(self.bounds.size.width - self.bigLeftViewLeftSpace - self.rightViewSize.width, y, self.rightViewSize.width, self.rightViewSize.height);
}

- (void)dealloc{
    NSLog(@"自定义导航栏:[%@] 释放", NSStringFromClass([self class]));
}

@end
