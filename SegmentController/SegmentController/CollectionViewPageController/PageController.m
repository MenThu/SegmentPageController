//
//  PageController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "PageController.h"
#import "PageCell.h"

@interface PageController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *pageView;
@property (nonatomic, assign) CGFloat headViewMaxHeight;
@property (nonatomic, assign) CGFloat headViewMinHeight;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) UIScrollView *currentListView;
@property (nonatomic, assign) BOOL isChangingContentOffset;
@property (nonatomic, assign) CGFloat currentScrollViewContentOffsetY;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *recordListHeadHeightArry;

@end

@implementation PageController

#pragma mark - LifrCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self configController];
    [self configNotification];
    [self configPageView];
}

- (void)configData{
    _currentPage = -1;
    _currentListView = nil;
    _isChangingContentOffset = NO;
    _recordListHeadHeightArry = @[].mutableCopy;
}

- (void)configController{
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
}

- (void)configNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listControllerScroll:) name:SubScrollViewDidScroll object:nil];
}

- (void)configPageView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0.f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.view.bounds.size;
    UICollectionView *pageView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    pageView.frame = self.view.bounds;
    pageView.pagingEnabled = YES;
    pageView.backgroundColor = [UIColor whiteColor];
    pageView.dataSource = self;
    pageView.delegate = self;
    [pageView registerClass:[PageCell class] forCellWithReuseIdentifier:@"PageCell"];
    [self.view addSubview:(_pageView = pageView)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Public
- (void)pageViewScroll2Page:(NSInteger)page{
    if (self.currentPage == page) {
        return;
    }
    self.currentPage = page;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
    [self.pageView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UICollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageCell *pageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
    pageCell.childControllerView = self.pageArray[indexPath.row].view;
//    self.currentPage = indexPath.row;
    return pageCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.pageView && scrollView.isDragging) {
        NSInteger currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.pageView.frame) + 0.5;
        self.currentPage = currentPage;
    }
}

#pragma mark - Notification
- (void)listControllerScroll:(NSNotification *)noti{
    UIScrollView *scrollView = (UIScrollView *)noti.object;
    if (scrollView == self.currentListView && self.isChangingContentOffset == NO) {
        CGFloat currentOffsetY = MAX(scrollView.contentOffset.y, -self.headViewMaxHeight);
        CGFloat deltaY = currentOffsetY - self.currentScrollViewContentOffsetY;
        CGFloat lastHeadHeight = CGRectGetHeight(self.headView.frame);
        CGFloat currentHeadViewHeight = lastHeadHeight - deltaY;
        self.currentScrollViewContentOffsetY = currentOffsetY;
        if (deltaY < 0) {//drag down
            if (currentOffsetY > -self.headViewMinHeight) {
                return;
            }
        }
//        NSLog(@"changeOffset=[%.2f],currentHeadViewHeight=[%.2f]", deltaY, currentHeadViewHeight);
        if (currentHeadViewHeight < self.headViewMinHeight) {
            currentHeadViewHeight = self.headViewMinHeight;
        }else if (currentHeadViewHeight > self.headViewMaxHeight){
            currentHeadViewHeight = self.headViewMaxHeight;
        }
        self.headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.headView.frame), currentHeadViewHeight);
        self.recordListHeadHeightArry[_currentPage] = @(currentHeadViewHeight);
    }
}

#pragma mark - Setter
- (void)setPageArray:(NSArray<ListController *> *)pageArray{
    _pageArray = pageArray;
    for (ListController *controller in pageArray) {
        [self addChildViewController:controller];
        controller.view.backgroundColor = [UIColor clearColor];
    }
    [self changeListViewContentInset];
}

- (void)setHeadView:(PageHeadView *)headView{
    if (_headView != nil) {
        [_headView removeFromSuperview];
    }
    if ([headView.superview isKindOfClass:[UIView class]]) {
        [headView removeFromSuperview];
    }
    self.headViewMaxHeight = [headView getMaxHeight];
    self.headViewMinHeight = [headView getMinHeight];
    __weak typeof(self) weakSelf = self;
    headView.panBlock = ^(BOOL isEnd, CGFloat yMoveLength) {
        CGPoint oldOffset = weakSelf.currentListView.contentOffset;
        CGFloat maxScrollOffset = weakSelf.currentListView.contentSize.height - weakSelf.currentListView.frame.size.height;
        CGFloat offsetY = oldOffset.y+yMoveLength;
        if (offsetY < -self.headViewMaxHeight) {
            offsetY = -self.headViewMaxHeight;
        }else if (offsetY > maxScrollOffset){
            offsetY = maxScrollOffset;
        }
        
        if (isEnd) {
            if (offsetY > -self.headViewMaxHeight && offsetY < -self.headViewMinHeight) {
                CGFloat middlePointY = (-self.headViewMaxHeight - self.headViewMinHeight)/2;
                if (offsetY > middlePointY) {
                    offsetY = -self.headViewMinHeight;
                }else{
                    offsetY = -self.headViewMaxHeight;
                }
            }
        }
        CGPoint newOffset = CGPointMake(oldOffset.x, offsetY);
        [weakSelf.currentListView setContentOffset:newOffset animated:isEnd];
    };
    headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.headViewMaxHeight);
    [self.view addSubview:(_headView = headView)];
    [self.view bringSubviewToFront:headView];
    [self changeListViewContentInset];
}

- (void)changeListViewContentInset{
    if (![self.headView isKindOfClass:[PageHeadView class]]) {
        return;
    }
    if ([self.pageArray isKindOfClass:[NSArray class]] == NO || self.pageArray.count <= 0) {
        return;
    }
    //代码运行到这里说明headView已经被赋值,那么headViewMaxHeight和headViewMinHeight一定有正确的值
    [self.recordListHeadHeightArry removeAllObjects];
    for (ListController *listController in self.pageArray) {
        [listController.scrollView setContentInset:UIEdgeInsetsMake(self.headViewMaxHeight, 0, 0, 0)];
        [listController.scrollView setContentOffset:CGPointMake(0, -self.headViewMaxHeight) animated:NO];
        listController.maxOffset = -self.headViewMinHeight;
        listController.minOffset = -self.headViewMaxHeight;
        [self.recordListHeadHeightArry addObject:@(self.headViewMaxHeight)];
    }
    self.currentPage = 0;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if (_currentPage == currentPage) {
        return;
    }
    self.isChangingContentOffset = YES;
    _currentPage = currentPage;
    self.currentListView = self.pageArray[currentPage].scrollView;
    CGFloat lastOffsetY = self.currentListView.contentOffset.y;
    CGFloat headViewHeight = CGRectGetHeight(self.headView.frame);
    CGFloat lastHeightViewHeight = self.recordListHeadHeightArry[currentPage].floatValue;
    CGPoint newPoint = CGPointZero;
    if (lastOffsetY < -headViewHeight) {//tableView和HeadView头裂缝，需要衔接上
        newPoint = CGPointMake(self.currentListView.contentOffset.x, -headViewHeight);
    }else{
        CGFloat minusHeight = lastHeightViewHeight - headViewHeight;
        if (minusHeight != 0) {
            newPoint = CGPointMake(self.currentListView.contentOffset.x, self.currentListView.contentOffset.y+minusHeight);
        }
    }
    self.recordListHeadHeightArry[currentPage] = @(headViewHeight);
    __weak typeof(self) weakSelf = self;
    if (CGPointEqualToPoint(CGPointZero, newPoint) == NO) {
//        [UIView animateWithDuration:0.25 animations:^{
//
//        }];
         self.currentListView.contentOffset = newPoint;
    }
//    NSLog(@"pageOffset=[%ld][%@]", (long)currentPage, NSStringFromCGPoint(self.currentListView.contentOffset));
    self.currentScrollViewContentOffsetY = self.currentListView.contentOffset.y;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.isChangingContentOffset = NO;
    });
}

@end
