//
//  MainTableController.m
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainTableController.h"
#import "MainTableCell.h"

@interface MainTableController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, readwrite) MainTableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, strong) NSArray <ContentController *> *contentControllerArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *recordOffsetArray;

@end

@implementation MainTableController

#pragma mark - LifeCircle
- (instancetype)initWith:(UIView *)headView
              headHeight:(CGFloat)headHeight
             segmentView:(UIView *)segmentView
           segmentHeight:(CGFloat)segmentHeight
       contentController:(NSArray <ContentController *> *)contentControllerArray{
    if (self = [super init]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.currentPage = 0;
        self.recordOffsetArray = @[@(0), @(0), @(0)].mutableCopy;
        self.headView = headView;
        self.headHeight = headHeight;
        self.segmentView = segmentView;
        self.segmentHeight = segmentHeight;
        self.contentControllerArray = contentControllerArray;
        MainTableView *tableView = [[MainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[MainTableCell class] forCellReuseIdentifier:@"MainTableCell"];
        [self.view addSubview:(_tableView = tableView)];
        [self.tableView reloadData];
        [self registerNotification];
    }
    return self;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.headView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), self.headHeight);
    self.tableView.tableHeaderView = self.headView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TableViewDidScroll" object:nil];
}

#pragma mark - Public
- (BOOL)canDragDown{
    return self.contentControllerArray[self.currentPage].tableView.contentOffset.y <= 0;
}

#pragma mark - Private
- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentScrollViewDidScoll:) name:@"TableViewDidScroll" object:nil];
}

- (void)contentScrollViewDidScoll:(NSNotification *)noti{
    UIScrollView *scrollView = (UIScrollView *)noti.object;
    if (scrollView != self.contentControllerArray[self.currentPage].tableView) {
        NSLog(@"????");
        return;
    }
    CGFloat lastOffset = self.recordOffsetArray[self.currentPage].floatValue;
    CGFloat minus = lastOffset - scrollView.contentOffset.y;
    if (minus < 0) {//drag up
        if (self.tableView.contentOffset.y < self.headHeight) {
            scrollView.contentOffset = CGPointMake(0, lastOffset);
        }
    }else if (minus > 0){//drag down
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointZero;
            if (!self.contentControllerArray[self.currentPage].tableView.isGestureDown) {
                NSLog(@"down 222");
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y-minus);
            }
        }else{
            self.tableView.contentOffset = CGPointMake(0, self.headHeight);
        }
    }
    self.recordOffsetArray[self.currentPage] = @(scrollView.contentOffset.y);
}

#pragma mark - Setter
- (void)setContentControllerArray:(NSArray<ContentController *> *)contentControllerArray{
    if ([_contentControllerArray isKindOfClass:[NSArray class]] && _contentControllerArray.count > 0) {
        for (ContentController *controller in _contentControllerArray) {
            [controller removeFromParentViewController];
        }
    }
    _contentControllerArray = contentControllerArray;
    for (ContentController *controller in _contentControllerArray) {
        [self addChildViewController:controller];
    }
}

#pragma mark - UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.tableView.bounds) - self.segmentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    MainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableCell" forIndexPath:indexPath];
    cell.contentControllerArray = self.contentControllerArray;
    cell.changePage = ^(NSInteger currentPage) {
        weakSelf.currentPage = currentPage;
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.segmentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.segmentHeight;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > self.headHeight) {
        scrollView.contentOffset = CGPointMake(0, self.headHeight);
    }
}

@end
