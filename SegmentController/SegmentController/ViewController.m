//
//  ViewController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/7.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ViewController.h"
#import "OneController.h"
#import "TwoController.h"
#import "PageController.h"
#import "MainTableController.h"
#import "ContentController.h"
#import "PersonProfileHeadView.h"
#import "DynamicController.h"
#import "ArticleController.h"
#import <objc/runtime.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *testTableView;
@property (nonatomic, strong) id testName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    UITableView *testTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    testTableView.bounces = NO;
    testTableView.delegate = self;
    testTableView.dataSource = self;
    [self.view insertSubview:(_testTableView = testTableView) atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"TEST=[%ld]", (long)indexPath.row];
    return cell;
}

#define IS_UICollectionView_UITableView 0
- (IBAction)push2Controller:(UIButton *)sender {
#if IS_UICollectionView_UITableView
    OneController *one = [[OneController alloc] init];
    TwoController *two = [[TwoController alloc] init];
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor orangeColor];
    UIView *segmentView = [UIView new];
    segmentView.backgroundColor = [UIColor cyanColor];
    PageController *pageController = [[PageController alloc] initWithHeadView:headView headViewHeight:100 segmentView:segmentView segmentHeight:50 pageArray:@[one, two]];
    [self.navigationController pushViewController:pageController animated:YES];
#else
    PersonProfileHeadView *headView = [PersonProfileHeadView loadView];
    UIView *segmentView = [UIView new];
    segmentView.backgroundColor = [UIColor cyanColor];
    DynamicController *dynamicController = [[DynamicController alloc] init];
    ArticleController *articleController = [[ArticleController alloc] init];
    MainTableController *mainController = [[MainTableController alloc] initWith:headView headHeight:300 segmentView:segmentView segmentHeight:50 contentController:@[dynamicController, articleController]];
    [self.navigationController pushViewController:mainController animated:YES];
#endif

}


- (void)deBugPrivateClass{
    //UIScrollViewPanGestureRecognizer
    //ViewController
    unsigned int count = 0;
    Ivar *var = class_copyIvarList(NSClassFromString(@"UIScrollViewPanGestureRecognizer"), &count);
    for (NSInteger index = 0; index < count; index ++) {
        Ivar _var = *(var+index);
        NSLog(@"Encoding=[%s]", ivar_getTypeEncoding(_var));
        NSLog(@"Name=[%s]", ivar_getName(_var));
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    NSLog(@"currentOffset=[%@]   targetOffset=[%@]   Veloticy=[%@]", NSStringFromCGPoint(self.testTableView.contentOffset), NSStringFromCGPoint(targetOffset), NSStringFromCGPoint(velocity));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
