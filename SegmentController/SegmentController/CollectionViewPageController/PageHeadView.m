//
//  PageHeadView.m
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "PageHeadView.h"
#import <Masonry.h>

static CGFloat const NaviBarHeight = 44.f;

@interface PageHeadView ()

@property (nonatomic, assign) CGPoint beginPoint;

@end


@implementation PageHeadView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    NSSet <UITouch *> *allSets = [event touchesForView:self];
//    NSArray *tempArray = [event allTouches].anyObject.gestureRecognizers;
    NSLog(@"hitTest:withEvent = [%ld][%ld] [%@]", (long)event.type, (long)event.subtype, [event allTouches]);
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView;
//    if (hitView == self) {
//        return nil;
//    }else{
//        return hitView;
//    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    NSArray *tempArray = [event allTouches];
//    NSSet <UITouch *> *allSets = [event touchesForView:self];
    NSLog(@"pointInside = [%ld][%ld] [%@]", (long)event.type, (long)event.subtype, [event allTouches]);
    return [super pointInside:point withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.userInteractionEnabled = NO;
    NSLog(@"touchesBegan=[%@]", [event allTouches].anyObject.gestureRecognizers);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved=[%@]", [event allTouches].anyObject.gestureRecognizers);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded=[%@]", [event allTouches].anyObject.gestureRecognizers);
}

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
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//    [self addGestureRecognizer:panGesture];
    
    __weak typeof(self) weakSelf = self;
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    testBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:testBtn];
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)clickBtn:(UIButton *)btn{
    NSLog(@"点击了按钮");
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
