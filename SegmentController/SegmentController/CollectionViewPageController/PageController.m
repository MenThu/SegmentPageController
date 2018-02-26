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

@interface PageController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UICollectionView *pageView;
@property (nonatomic, strong) UIView *wholeTopView;
@property (nonatomic, weak) UIView *headView;
@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, weak) UIView *segmentView;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, strong) NSArray <ListController *> *pageArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) UIScrollView *currentListView;
@property (nonatomic, assign) BOOL isChangingContentOffset;
@property (nonatomic, assign) CGFloat currentScrollViewContentOffsetY;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *recordListHeadHeightArry;

@end

@implementation PageController

#pragma mark - LifrCircle
- (instancetype)initWithHeadView:(UIView *)headView
                  headViewHeight:(CGFloat)headHeight
                     segmentView:(UIView *)segmentView
                   segmentHeight:(CGFloat)segmentHeight
                       pageArray:(NSArray<ListController *> *)pageArray{
    if (self = [super init]) {
        NSLog(@"initWithHeadView");
        self.headHeight = headHeight;
        self.segmentHeight = segmentHeight;
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
    NSLog(@"viewDidLoad");
    [self configData];
    [self configController];
    [self configPageView];
    [self configWholeTopView];
}

- (void)configData{
    _currentPage = -1;
    _currentListView = nil;
    _isChangingContentOffset = NO;
    _recordListHeadHeightArry = @[].mutableCopy;
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

//- (void)configNotification{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listControllerScroll:) name:SubScrollViewDidScroll object:nil];
//}

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

- (void)configWholeTopView{
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    self.headView.frame = CGRectMake(0, 0, viewWidth, self.headHeight);
    self.segmentView.frame = CGRectMake(0, self.headHeight, viewWidth, self.segmentHeight);
    self.wholeTopView.frame = CGRectMake(0, 0, CGRectGetWidth(self.pageView.frame), self.headHeight + self.segmentHeight);
    [self.view addSubview:self.wholeTopView];
    [self.view bringSubviewToFront:self.wholeTopView];
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

- (void)hitPoint:(CGPoint)point{
    if (CGRectContainsPoint(self.headView.frame, point)) {
        [self.headView addGestureRecognizer:self.currentListView.panGestureRecognizer];
    }else{
        [self.currentListView addGestureRecognizer:self.currentListView.panGestureRecognizer];
    }
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

#pragma mark - Notification
- (void)listControllerScroll:(NSNotification *)noti{
    UIScrollView *scrollView = (UIScrollView *)noti.object;
    if (scrollView == self.currentListView && self.isChangingContentOffset == NO) {
//        CGFloat currentOffsetY = MAX(scrollView.contentOffset.y, -self.headViewMaxHeight);
//        CGFloat deltaY = currentOffsetY - self.currentScrollViewContentOffsetY;
//        CGFloat lastHeadHeight = CGRectGetHeight(self.headView.frame);
//        CGFloat currentHeadViewHeight = lastHeadHeight - deltaY;
//        self.currentScrollViewContentOffsetY = currentOffsetY;
//        if (deltaY < 0) {//drag down
//            if (currentOffsetY > -self.headViewMinHeight) {
//                return;
//            }
//        }
//        if (currentHeadViewHeight < self.headViewMinHeight) {
//            currentHeadViewHeight = self.headViewMinHeight;
//        }else if (currentHeadViewHeight > self.headViewMaxHeight){
//            currentHeadViewHeight = self.headViewMaxHeight;
//        }
//        self.headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.headView.frame), currentHeadViewHeight);
//        self.recordListHeadHeightArry[_currentPage] = @(currentHeadViewHeight);
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
    if(context == &SCROLLView_CONTENTOFFSET && object == self.currentListView) {
        CGFloat oldOffsetY          = [change[NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat newOffsetY          = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat deltaY              = newOffsetY - oldOffsetY;
        if (deltaY > 0) {//drag up
            
        }else if (deltaY < 0){
            
        }
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

//- (void)setHeadView:(PageHeadView *)headView{
//    if (_headView != nil) {
//        [_headView removeFromSuperview];
//    }
//    if ([headView.superview isKindOfClass:[UIView class]]) {
//        [headView removeFromSuperview];
//    }
//    headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.headViewMaxHeight);
//    [self.view addSubview:(_headView = headView)];
//    [self.view bringSubviewToFront:headView];
//    [self changeListViewContentInset];
//}

- (void)changeListViewContentInset{
//    if (![self.headView isKindOfClass:[PageHeadView class]]) {
//        return;
//    }
//    if ([self.pageArray isKindOfClass:[NSArray class]] == NO || self.pageArray.count <= 0) {
//        return;
//    }
    CGFloat wholeTopSpace = self.headHeight + self.segmentHeight;
    //代码运行到这里说明headView已经被赋值,那么headViewMaxHeight和headViewMinHeight一定有正确的值
    [self.recordListHeadHeightArry removeAllObjects];
    for (ListController *listController in self.pageArray) {
        [listController.scrollView setContentInset:UIEdgeInsetsMake(wholeTopSpace, 0, 0, 0)];
        [listController.scrollView setContentOffset:CGPointMake(0, -wholeTopSpace) animated:NO];
        [self addKvoForScrollView:listController.scrollView];
        [self.recordListHeadHeightArry addObject:@(wholeTopSpace)];
    }
    self.currentPage = 0;
}

- (void)setCurrentPage:(NSInteger)currentPage{
//    if (_currentPage == currentPage) {
//        return;
//    }
//    self.isChangingContentOffset = YES;
//    _currentPage = currentPage;
//    self.currentListView = self.pageArray[currentPage].scrollView;
//    CGFloat lastOffsetY = self.currentListView.contentOffset.y;
//    CGFloat headViewHeight = CGRectGetHeight(self.headView.frame);
//    CGFloat lastHeightViewHeight = self.recordListHeadHeightArry[currentPage].floatValue;
//    CGPoint newPoint = CGPointZero;
//    if (lastOffsetY < -headViewHeight) {//tableView和HeadView头裂缝，需要衔接上
//        newPoint = CGPointMake(self.currentListView.contentOffset.x, -headViewHeight);
//    }else{
//        CGFloat minusHeight = lastHeightViewHeight - headViewHeight;
//        if (minusHeight != 0) {
//            newPoint = CGPointMake(self.currentListView.contentOffset.x, self.currentListView.contentOffset.y+minusHeight);
//        }
//    }
//    self.recordListHeadHeightArry[currentPage] = @(headViewHeight);
//    __weak typeof(self) weakSelf = self;
//    if (CGPointEqualToPoint(CGPointZero, newPoint) == NO) {
//         self.currentListView.contentOffset = newPoint;
//    }
//    self.currentScrollViewContentOffsetY = self.currentListView.contentOffset.y;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        weakSelf.isChangingContentOffset = NO;
//    });
}

@end
