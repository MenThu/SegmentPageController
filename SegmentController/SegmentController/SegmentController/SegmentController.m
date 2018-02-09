//
//  SegmentController.m
//  BigTitleNavigationController
//
//  Created by MenThu on 2018/1/18.
//  Copyright © 2018年 admin. All rights reserved.
//

static void *SegmentControllerContentScrollViewOffset = &SegmentControllerContentScrollViewOffset;

#import "SegmentController.h"
#import "SegmentControllerView.h"
#import "SegmentPageCell.h"
#import <MJRefresh/MJRefresh.h>

@interface SegmentController ()

@property (nonatomic, weak, readwrite) UICollectionView *collectionView;
@property (nonatomic, weak, readwrite) SegmentNaviBar *customNaviBar;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *pageHeadHeight;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SegmentController

- (void)loadView{
    SegmentControllerView *view = [SegmentControllerView new];
    view.controller = self;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //添加分栏控制器
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.contentInset = UIEdgeInsetsZero;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[SegmentPageCell class] forCellWithReuseIdentifier:@"SegmentPageCell"];
    [self.view addSubview:(_collectionView = collectionView)];
    
    //添加自定义导航栏
    [self.view addSubview:(_customNaviBar = [self customNaviBarInterface])];
    self.maxHeight = self.customNaviBar.maxHeight;
    self.minHeight = self.customNaviBar.normalHeight;
    self.customNaviBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.maxHeight);
    self.title = @"控制器";
    self.pageHeadHeight = @[@(self.maxHeight), @(self.maxHeight), @(self.maxHeight)].mutableCopy;
}

- (void)dealloc{
    NSLog(@"[%@] die", NSStringFromClass([self class]));
    for(UIScrollView *scrollView in self.contentViewArray) {
        [scrollView removeObserver:self forKeyPath:@"contentOffset" context:&SegmentControllerContentScrollViewOffset];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.collectionView.bounds.size;
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - OverWrite
- (SegmentNaviBar *)customNaviBarInterface{
    return [[SegmentNaviBar alloc] init];
}

- (void)showPage:(NSInteger)page{
    
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title{
    self.customNaviBar.naviTitle = title;
}

- (void)setContentViewArray:(NSArray<UIView *> *)contentViewArray{
    NSMutableArray <UIScrollView *> *scrollViewArray = @[].mutableCopy;
    for(UIView *contentView in contentViewArray) {
        UIScrollView *scrollView = nil;
        if ([contentView isKindOfClass:[UIScrollView class]] == NO) {
            scrollView = [[UIScrollView alloc] init];
            [scrollView addSubview:contentView];
        }else{
            scrollView = (UIScrollView *)contentView;
        }
        scrollView.mj_header.hidden = YES;
        [scrollView setContentInset:UIEdgeInsetsMake(self.customNaviBar.maxHeight, 0, 0, 0)];
        scrollView.showsVerticalScrollIndicator = NO;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&SegmentControllerContentScrollViewOffset];
        [scrollViewArray addObject:scrollView];
    }
    scrollViewArray[0].mj_header.hidden = NO;
    _contentViewArray = scrollViewArray;
    for (UIScrollView *scrollView in scrollViewArray) {
        NSLog(@"scrollView=[%p]", scrollView);
    }
    _currentPage = 0;
    self.currentContentView = (UIScrollView *)_contentViewArray.firstObject;
    [self.collectionView reloadData];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if (_currentPage == currentPage) {
        return;
    }
    _currentPage = currentPage;
    CGFloat height;
    self.currentContentView = (UIScrollView *)self.contentViewArray[currentPage];
    CGFloat offset = self.currentContentView.contentOffset.y;
    if (offset <= -self.maxHeight) {
        height = self.maxHeight;
    }else if (offset >= -self.minHeight){
        height = self.minHeight;
    }else{
        height = fabs(offset);
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.customNaviBar.frame = CGRectMake(0, 0, weakSelf.customNaviBar.frame.size.width, height);
        [weakSelf.customNaviBar layoutIfNeeded];
    } completion:^(BOOL finished) {
        for (UIScrollView *scrollView in weakSelf.contentViewArray) {
            scrollView.mj_header.hidden = YES;
        }
        UIScrollView *scrollView = (UIScrollView *)weakSelf.contentViewArray[weakSelf.currentPage];
        scrollView.mj_header.hidden = NO;
    }];
    [self showPage:currentPage];
}

#pragma mark - Collectionview代理数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger cellCount = self.contentViewArray.count;
    return cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const reuesString = @"SegmentPageCell";
    SegmentPageCell *segmentPageCell = (SegmentPageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuesString forIndexPath:indexPath];
    segmentPageCell.subContentView = self.contentViewArray[indexPath.row];
    return segmentPageCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        NSInteger currentPage = (scrollView.contentOffset.x / scrollView.bounds.size.width) + 0.5;
        if (currentPage < 0) {
            currentPage = 0;
        }else if (currentPage > self.contentViewArray.count-1){
            currentPage = self.contentViewArray.count-1;
        }
        self.currentPage = currentPage;
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == &SegmentControllerContentScrollViewOffset && _contentViewArray[_currentPage] == object) {
//        CGFloat newOffsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y
//        CGFloat height;
//        if (newOffsetY >= -self.minHeight) {
//            height = self.minHeight;
//        }else if (newOffsetY <= -self.maxHeight){
//            height = self.maxHeight;
//        }else{
//            height = fabs(newOffsetY);
//        }
//        self.customNaviBar.frame = CGRectMake(0, 0, self.customNaviBar.frame.size.width, height);
//        self.pageHeadHeight[_currentPage] = @(height);
        
//        UIScrollView *scrollView = (UIScrollView *)object;
//        if (scrollView.isDragging) {
//            NSLog(@"reset");
//            CGPoint oldOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
//            scrollView.contentOffset = oldOffset;
//        }
//        CGFloat newOffsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
//        if (newOffsetY >= -self.maxHeight && newOffsetY <= -self.minHeight) {
//            return;
//        }
//
//
//        CGFloat height;
//        if (newOffsetY >= -self.minHeight) {
//            height = self.minHeight;
//        }else if (newOffsetY <= -self.maxHeight){
//            height = self.maxHeight;
//        }else{
//            height = fabs(newOffsetY);
//        }
//        self.customNaviBar.frame = CGRectMake(0, 0, self.customNaviBar.frame.size.width, height);
//        self.pageHeadHeight[_currentPage] = @(height);
    }
}

@end
