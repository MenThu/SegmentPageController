//
//  TestController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "TestController.h"
#import "HitTestView.h"
#import <Masonry.h>

@interface TestController ()

@property (nonatomic, weak) HitTestView *testSubView;

@end

@implementation TestController

- (void)loadView{
    HitTestView *view = [HitTestView new];
    view.backgroundColor = [UIColor cyanColor];
    //    view.bounds = [UIScreen mainScreen].bounds.size;
    view.viewName = @"TestControllerView";
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    HitTestView *testSubView = [HitTestView new];
    testSubView.viewName = @"testSubView";
    testSubView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:(_testSubView = testSubView)];
    [testSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).multipliedBy(0.5);
        make.height.equalTo(weakSelf.view).multipliedBy(0.5);
    }];
}

@end
