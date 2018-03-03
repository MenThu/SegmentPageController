//
//  PageController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/8.
//  Copyright © 2018年 MenThu. All rights reserved.
//

static void *SCROLLView_CONTENTOFFSET = &SCROLLView_CONTENTOFFSET;

#import "PageController.h"
#import "PageCell.h"
#import "PageControllerView.h"
#import <MJRefresh.h>

@interface PageController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, weak, readwrite) UICollectionView *pageView;
@property (nonatomic, strong, readwrite) UIView *wholeTopView;
@property (nonatomic, weak) UIView *headView;
@property (nonatomic, weak) UIView *segmentView;
@property (nonatomic, strong) NSArray <ListController *> *pageArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) UIScrollView *currentListView;
@property (nonatomic, assign) BOOL isChangingContentOffset;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *recordTopViewMaxYArray;

@end

@implementation PageController

#pragma mark - LifrCircle
- (instancetype)initWithHeadView:(UIView *)headView
                  headViewHeight:(CGFloat)headHeight
                     segmentView:(UIView *)segmentView
                   segmentHeight:(CGFloat)segmentHeight
                       pageArray:(NSArray<ListController *> *)pageArray{
    if (self = [super init]) {
        NSAssert(headView != nil, @"");
        NSAssert(headHeight > 0, @"");
        NSAssert(segmentView != nil, @"");
        NSAssert(segmentHeight > 0, @"");
        _headHeight = headHeight;
        _segmentHeight = segmentHeight;
        UIView *wholeTopView = [UIView new];
        [wholeTopView addSubview:(_headView = headView)];
        [wholeTopView addSubview:(_segmentView = segmentView)];
        self.wholeTopView = wholeTopView;
        self.pageArray = pageArray;        
    }
    return self;
}

- (void)loadView{
    PageControllerView *controllerView = [[PageControllerView alloc] init];
    controllerView.frame = [UIScreen mainScreen].bounds;
    self.view = controllerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configData];
    [self configController];
    [self configPageView];
    [self.view addSubview:self.wholeTopView];
    [self.view bringSubviewToFront:self.wholeTopView];
    [self layoutTopView];
}

- (void)layoutTopView{
    [self configWholeTopView];
    [self changeListViewContentInset];
}

- (void)configData{
    _currentPage = -1;
    _currentListView = nil;
    _isChangingContentOffset = NO;
    _recordTopViewMaxYArray = @[].mutableCopy;
}

- (void)configController{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
}

- (void)dealloc{
    for (ListController *controller in self.pageArray) {
        [self removeKvoFroScrollView:controller.scrollView];
    }
}

- (void)configPageView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0.f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.view.bounds.size;
    UICollectionView *pageView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    pageView.showsHorizontalScrollIndicator = NO;
    pageView.frame = self.view.bounds;
    pageView.pagingEnabled = YES;
    pageView.backgroundColor = [UIColor whiteColor];
    pageView.dataSource = self;
    pageView.delegate = self;
    [pageView registerClass:[PageCell class] forCellWithReuseIdentifier:@"PageCell"];
    [self.view addSubview:(_pageView = pageView)];
}

- (void)configWholeTopView{
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    self.headView.frame = CGRectMake(0, 0, viewWidth, self.headHeight);
    self.segmentView.frame = CGRectMake(0, self.headHeight, viewWidth, self.segmentHeight);
    self.wholeTopView.frame = CGRectMake(0, 0, CGRectGetWidth(self.pageView.frame), self.headHeight + self.segmentHeight);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.pageView.frame = self.view.bounds;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.pageView.collectionViewLayout;
    layout.itemSize = self.pageView.bounds.size;
    CGFloat width = CGRectGetWidth(self.wholeTopView.frame);
    self.headView.frame = CGRectMake(0, 0, width, self.headHeight);
    self.segmentView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), width, self.segmentHeight);
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

- (void)hitPoint:(CGPoint)point{
    if (CGRectContainsPoint(self.wholeTopView.frame, point)) {
        [self.wholeTopView addGestureRecognizer:self.currentListView.panGestureRecognizer];
    }else{
        [self.currentListView addGestureRecognizer:self.currentListView.panGestureRecognizer];
    }
}

- (void)scroll2Page:(NSInteger)page{
    
}

#pragma mark - UICollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageCell *pageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
    pageCell.childControllerView = self.pageArray[indexPath.row].view;
    return pageCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.pageView && scrollView.isDragging) {
        NSInteger currentPage = scrollView.contentOffset.x / CGRectGetWidth(self.pageView.frame) + 0.5;
        self.currentPage = currentPage;
    }
}

#pragma mark - KVO
- (void)addKvoForScrollView:(UIScrollView *)scrollView{
    NSAssert(scrollView != nil, @"");
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&SCROLLView_CONTENTOFFSET];
}

- (void)removeKvoFroScrollView:(UIScrollView *)scrollView{
    [scrollView removeObserver:self forKeyPath:@"contentOffset" context:&SCROLLView_CONTENTOFFSET];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if(context == &SCROLLView_CONTENTOFFSET && object == self.currentListView && self.isChangingContentOffset == NO) {
        CGFloat oldOffsetY          = [change[NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat newOffsetY          = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat wholeTopSpace = self.headHeight + self.segmentHeight;
        CGFloat originWidth = CGRectGetWidth(self.wholeTopView.frame);
        if (oldOffsetY < -wholeTopSpace) {
            return;
        }
        if (newOffsetY < -self.headHeight - self.segmentHeight) {
            self.wholeTopView.frame = CGRectMake(0, 0, originWidth, wholeTopSpace);
        }
        CGFloat deltaY = newOffsetY - oldOffsetY;
        CGFloat originY = CGRectGetMinY(self.wholeTopView.frame);
        if (deltaY > 0) {//drag up
            originY -= deltaY;
            if (originY < -self.headHeight) {
                originY = -self.headHeight;
            }
        }else if (deltaY < 0){
            if (newOffsetY > -CGRectGetMaxY(self.wholeTopView.frame)) {
                return;
            }
            originY -= deltaY;
            if (originY > 0) {
                originY = 0;
            }
        }
        self.wholeTopView.frame = CGRectMake(0, originY, originWidth, wholeTopSpace);
        self.recordTopViewMaxYArray[_currentPage] = @(CGRectGetMaxY(self.wholeTopView.frame));
    }
}

#pragma mark - Setter
- (void)setPageArray:(NSArray<ListController *> *)pageArray{
    _pageArray = pageArray;
    for (ListController *controller in pageArray) {
        [self addChildViewController:controller];
        controller.view.backgroundColor = [UIColor clearColor];
        [self addKvoForScrollView:controller.scrollView];
    }
}

- (void)changeListViewContentInset{
    CGFloat wholeTopSpace = self.headHeight + self.segmentHeight;
    [self.recordTopViewMaxYArray removeAllObjects];
    for (ListController *listController in self.pageArray) {
        [listController.scrollView setContentInset:UIEdgeInsetsMake(wholeTopSpace, 0, 0, 0)];
        [listController.scrollView setContentOffset:CGPointMake(0, -wholeTopSpace) animated:NO];
        [listController.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(wholeTopSpace, 0, 0, 0)];
        [self.recordTopViewMaxYArray addObject:@(wholeTopSpace)];
    }
    self.currentPage = 0;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if (_currentPage == currentPage) {
        return;
    }
    _currentPage = currentPage;
    [self scroll2Page:currentPage];
    self.isChangingContentOffset = YES;
    self.currentListView = self.pageArray[currentPage].scrollView;
    CGFloat contentOffsetY = self.currentListView.contentOffset.y;
    CGFloat wholeTopViewMaxY = CGRectGetMaxY(self.wholeTopView.frame);
    CGFloat lastTopViewY = self.recordTopViewMaxYArray[currentPage].floatValue;
    CGPoint newPoint = CGPointZero;
//    CGFloat maxOffset = self.currentListView.contentSize.height - CGRectGetHeight(self.currentListView.bounds);
    if (contentOffsetY < -wholeTopViewMaxY) {//tableView和HeadView头裂缝，需要衔接上
//        NSLog(@"not change = [%@]", NSStringFromUIEdgeInsets(self.currentListView.contentInset));
//        if (maxOffset < -wholeTopViewMaxY) {
//            self.currentListView.contentInset = UIEdgeInsetsMake(wholeTopViewMaxY, 0, 0, 0);
//            self.currentListView.scrollIndicatorInsets = UIEdgeInsetsMake(wholeTopViewMaxY, 0, 0, 0);
//            NSLog(@"change = [%@]", NSStringFromUIEdgeInsets(self.currentListView.contentInset));
//            self.currentListView.mj_footer.hidden = YES;
//        }
        newPoint = CGPointMake(self.currentListView.contentOffset.x, -wholeTopViewMaxY);
    }else{
        CGFloat minusHeight = lastTopViewY - wholeTopViewMaxY;
        if (minusHeight != 0) {
            newPoint = CGPointMake(self.currentListView.contentOffset.x, self.currentListView.contentOffset.y+minusHeight);
        }
    }
    self.recordTopViewMaxYArray[currentPage] = @(wholeTopViewMaxY);
    __weak typeof(self) weakSelf = self;
    if (CGPointEqualToPoint(CGPointZero, newPoint) == NO) {
         self.currentListView.contentOffset = newPoint;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.isChangingContentOffset = NO;
    });
}

- (void)setSegmentHeight:(CGFloat)segmentHeight{
    _segmentHeight = segmentHeight;
    [self layoutTopView];
}

- (void)setHeadHeight:(CGFloat)headHeight{
    _headHeight = headHeight;
    [self layoutTopView];
}

@end
