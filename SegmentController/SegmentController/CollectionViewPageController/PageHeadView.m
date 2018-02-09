//
//  PageHeadView.m
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "PageHeadView.h"

static CGFloat const NaviBarHeight = 44.f;

@interface PageHeadView ()

@property (nonatomic, assign) CGPoint beginPoint;

@end


@implementation PageHeadView

#pragma mark - LifeCircle
- (void)awakeFromNib{
    [super awakeFromNib];
    [self configView];
}

- (instancetype)init{
    if (self = [super init]) {
        [self configView];
    }
    return self;
}

- (void)configView{
    self.backgroundColor = [UIColor orangeColor];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
}

#pragma mark - Public
- (CGFloat)getMaxHeight{
    return 200.f;
}

- (CGFloat)getMinHeight{
    return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + NaviBarHeight;
}

#pragma mark - Private
- (void)panGesture:(UIPanGestureRecognizer *)gesture{
    if (self.panBlock == nil) {
        return;
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture translationInView:self];
            CGPoint velcity = [gesture velocityInView:self];
            [gesture setTranslation:CGPointZero inView:self];
            NSLog(@"change=[%@], velcity=[%@]", NSStringFromCGPoint(point), NSStringFromCGPoint(velcity));
            self.panBlock(NO, -point.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = [gesture velocityInView:self];
            [gesture setTranslation:CGPointZero inView:self];
//            NSLog(@"velcity=[%@]", NSStringFromCGPoint(velcity));
            CGFloat offsetPerVeloCity = 0.023754;
            CGFloat moveSpace = velocity.y * offsetPerVeloCity;
            self.panBlock(YES, -moveSpace);
        }
            break;
            
        default:
            break;
    }
}

@end
