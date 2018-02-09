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
#import "MainScrollController.h"
#import "ListOneController.h"
#import "ListTwoController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *testTableView;

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
//    testTableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    testTableView.delegate = self;
    testTableView.dataSource = self;
    [self.view insertSubview:(_testTableView = testTableView) atIndex:0];
//    [self.view addSubview:(_testTableView = testTableView)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (IBAction)push2Controller:(UIButton *)sender {
//    OneController *one = [[OneController alloc] init];
//    TwoController *two = [[TwoController alloc] init];
//    PageHeadView *headView = [[PageHeadView alloc] init];
//    PageController *pageController = [[PageController alloc] init];
//    pageController.pageArray = @[one, two];
//    pageController.headView = headView;
//    [self.navigationController pushViewController:pageController animated:YES];
    
    
    ListOneController *oneController = [ListOneController new];
    ListTwoController *twoController = [ListTwoController new];
    MainScrollController *mainController = [[MainScrollController alloc] init];
    mainController.controllerArray = @[oneController, twoController];
    [self.navigationController pushViewController:mainController animated:YES];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    
    CGFloat offsetPerVelcity = fabs(self.testTableView.contentOffset.y - targetOffset.y)/velocity.y;
    
    
    NSLog(@"currentOffset=[%@]   targetOffset=[%@]   Veloticy=[%@] offsetPerVelcity:[%.2f]", NSStringFromCGPoint(self.testTableView.contentOffset),NSStringFromCGPoint(targetOffset), NSStringFromCGPoint(velocity), offsetPerVelcity);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
