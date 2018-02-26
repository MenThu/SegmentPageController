//
//  MainScrollController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainScrollController.h"
#import "HorizonPageCell.h"
#import "MultipleTable.h"
#import <Masonry.h>

@interface MainScrollController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *bottomTableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, assign) CGFloat tableHeadHeight;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, assign) CGFloat sectionHeight;
@property (nonatomic, strong) NSArray<CommonTableController *> *controllerArray;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, weak) UIScrollView *currentListView;
@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation MainScrollController

#pragma mark - LifeCircle
- (instancetype)initWithTableHeadView:(UIView *)tableHeadView
                           headHeight:(CGFloat)headHeight
                          sectionView:(UIView *)sectionView
                        sectionHeight:(CGFloat)sectionHeight
                contentControlerArray:(NSArray<CommonTableController *> *)controllerArray{
    if (self = [super init]) {
        self.tableHeadView = tableHeadView;
        self.tableHeadHeight = headHeight;
        self.sectionView = sectionView;
        self.sectionHeight = sectionHeight;
        self.controllerArray = controllerArray;
    }
    return self;
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
    [self initData];
    [self initView];
}

- (void)initData{
    self.cellHeight = CGRectGetHeight(self.view.bounds) - self.sectionHeight;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listControllerScroll:) name:CommonTableScroll object:nil];
}

- (void)initView{
    UITableView *bottomTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bottomTableView.showsVerticalScrollIndicator = NO;
    bottomTableView.dataSource = self;
    bottomTableView.delegate = self;
    [bottomTableView registerClass:[HorizonPageCell class] forCellReuseIdentifier:@"HorizonPageCell"];
    [self.view addSubview:(_bottomTableView = bottomTableView)];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"[%@][%s]", NSStringFromClass([self class]), sel_getName(_cmd));
    self.tableHeadView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bottomTableView.frame), self.tableHeadHeight);
    self.bottomTableView.tableHeaderView = self.tableHeadView;
}

#pragma mark - Private
- (void)listControllerScroll:(NSNotification *)noti{
    UIScrollView *scrollView = (MultipleTable *)noti.object;
    if (self.currentListView == nil) {
        self.currentListView = scrollView;
        self.lastOffsetY = 0;
    }
    if (self.currentListView == scrollView) {
        CGFloat currentOffset = scrollView.contentOffset.y;
        CGFloat deltaY = currentOffset - self.lastOffsetY;
        if (deltaY > 0) {//drag up
            if (self.bottomTableView.contentOffset.y < self.tableHeadHeight) {
                scrollView.contentOffset = CGPointZero;
            }else{
                if (self.bottomTableView.contentOffset.y > self.tableHeadHeight) {
                    self.bottomTableView.contentOffset = CGPointMake(0, self.tableHeadHeight);
                }
            }
        }else if (deltaY < 0){//drag down
            NSLog(@"drag down");
            if (currentOffset > 0) {
                NSLog(@"drag down=[xxxxx]");
                self.bottomTableView.contentOffset = CGPointMake(0, self.tableHeadHeight);
            }else{
                NSLog(@"drag down=[yyyyy]");
                scrollView.contentOffset = CGPointZero;
            }
        }
        self.lastOffsetY = scrollView.contentOffset.y;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.sectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HorizonPageCell *horizonCell = [tableView dequeueReusableCellWithIdentifier:@"HorizonPageCell" forIndexPath:indexPath];
    horizonCell.backgroundColor = [UIColor cyanColor];
    __weak typeof(self) weakSelf = self;
    horizonCell.changePage = ^(UIScrollView *listView) {
        weakSelf.currentListView = listView;
        weakSelf.lastOffsetY = weakSelf.currentListView.contentOffset.y;
    };
    horizonCell.controllerArray = self.controllerArray;
    return horizonCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
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
    self.currentListView = controllerArray[0].tableView;
}

@end
