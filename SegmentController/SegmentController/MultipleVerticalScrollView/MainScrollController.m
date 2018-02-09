//
//  MainScrollController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainScrollController.h"
#import "HitTestView.h"
#import "MultipleTable.h"
#import "HorizonPageCell.h"
#import <Masonry.h>

@interface MainScrollController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) MultipleTable *bottomTableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, assign) CGFloat tableHeadHeight;
@property (nonatomic, assign) CGFloat sectionHeadHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation MainScrollController

#pragma mark - LifeCircle
- (void)loadView{
    HitTestView *view = [HitTestView new];
    view.frame = [UIScreen mainScreen].bounds;
    view.backgroundColor = [UIColor whiteColor];
    view.viewName = @"MainControllerView";
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    self.tableHeadHeight = 150.f;
    self.sectionHeadHeight = 30.f;
    self.cellHeight = CGRectGetHeight(self.view.bounds) - self.sectionHeadHeight;
    
    self.tableHeadView = [UIView new];
    self.tableHeadView.backgroundColor = [UIColor orangeColor];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"[%@][%s]", NSStringFromClass([self class]), sel_getName(_cmd));
    self.bottomTableView.frame = self.view.bounds;
    self.tableHeadView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bottomTableView.frame), self.tableHeadHeight);
    self.bottomTableView.tableHeaderView = self.tableHeadView;
}

#pragma mark - Getter
- (MultipleTable *)bottomTableView{
    if (_bottomTableView == nil) {
        MultipleTable *bottomTableView = [[MultipleTable alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        bottomTableView.showsVerticalScrollIndicator = NO;
//        bottomTableView.bounces = NO;
        bottomTableView.dataSource = self;
        bottomTableView.delegate = self;
        [bottomTableView registerClass:[HorizonPageCell class] forCellReuseIdentifier:@"HorizonPageCell"];
        [self.view addSubview:(_bottomTableView = bottomTableView)];
    }
    return _bottomTableView;
}

#pragma mark - Setter
- (void)setControllerArray:(NSArray<CommonTableController *> *)controllerArray{
    if ([_controllerArray isKindOfClass:[NSArray class]] && _controllerArray.count > 0) {
        for (CommonTableController *controller in _controllerArray) {
            [controller removeFromParentViewController];
        }
    }
    _controllerArray = controllerArray;
    for (CommonTableController *controller in _controllerArray) {
        [self addChildViewController:controller];
    }
    [self.bottomTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHead = [[UIView alloc] init];
    sectionHead.backgroundColor = [UIColor blackColor];
    return sectionHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.sectionHeadHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HorizonPageCell *horizonCell = [tableView dequeueReusableCellWithIdentifier:@"HorizonPageCell" forIndexPath:indexPath];
    horizonCell.backgroundColor = [UIColor cyanColor];
    horizonCell.controllerArray = self.controllerArray;
    return horizonCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

@end
