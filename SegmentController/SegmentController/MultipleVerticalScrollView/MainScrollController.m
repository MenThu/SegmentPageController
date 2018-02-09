//
//  MainScrollController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainScrollController.h"
#import "HitTestView.h"
#import "TestController.h"
#import <Masonry.h>

@interface MainScrollController ()

@property (nonatomic, weak) HitTestView *subView1;
@property (nonatomic, weak) HitTestView *subView2;

@end

@implementation MainScrollController

- (void)loadView{
    HitTestView *view = [HitTestView new];
    view.backgroundColor = [UIColor whiteColor];
//    view.bounds = [UIScreen mainScreen].bounds.size;
    view.viewName = @"MainControllerView";
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    
    HitTestView *subView1 = [HitTestView new];
    subView1.viewName = @"subView1";
    subView1.backgroundColor = [UIColor orangeColor];
    
    
    TestController *childController = [[TestController alloc] init];
    [self addChildViewController:childController];
    
    [self.view addSubview:childController.view];
    [self.view addSubview:(_subView1 = subView1)];
    
    
    
    
    [subView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(80);
        make.right.equalTo(weakSelf.view.mas_centerX).offset(-50);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
//    [subView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(subView1);
//        make.left.equalTo(weakSelf.view.mas_centerX).offset(50);
//        make.size.equalTo(subView1);
//    }];
    
    [childController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_centerY);
        make.left.right.equalTo(weakSelf.view);
        make.size.equalTo(weakSelf.view);
    }];
}

- (HitTestView *)subView2{
    if (_subView2 == nil) {
        
        HitTestView *subView2 = [HitTestView new];
        subView2.viewName = @"subView2";
        subView2.backgroundColor = [UIColor yellowColor];
        
        HitTestView *subViewInSubView2 = [HitTestView new];
        subViewInSubView2.viewName = @"subViewInSubView2";
        subViewInSubView2.backgroundColor = [UIColor blackColor];
        [subView2 addSubview:subViewInSubView2];
        
        [subViewInSubView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(subView2);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.view addSubview:(_subView2 = subView2)];
    }
    return _subView2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
