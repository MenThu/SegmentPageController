//
//  MainTableController.m
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainTableController.h"
#import "MainControllerView.h"

@interface _CollectionPageCell : UICollectionViewCell

@property (nonatomic, weak) UIView *controllerView;

@end

@implementation _CollectionPageCell

- (void)setControllerView:(UIView *)controllerView{
    if (_controllerView) {
        [_controllerView removeFromSuperview];
    }
    controllerView.frame = self.contentView.bounds;
    [self.contentView addSubview:(_controllerView = controllerView)];
}

@end

@interface MainTableController () <UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak, readwrite) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat currentOffsetY;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, strong, readwrite) UIView *wholeTopView;
@property (nonatomic, assign) CGFloat wholeTopViewHeight;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <ContentController *> *contentControllerArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *recordOffsetArray;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, weak) UIScrollView *currentScrollView;

@end

@implementation MainTableController

#pragma mark - LifeCircle
- (instancetype)initWith:(UIView *)headView
              headHeight:(CGFloat)headHeight
             segmentView:(UIView *)segmentView
           segmentHeight:(CGFloat)segmentHeight
       contentController:(NSArray <ContentController *> *)contentControllerArray{
    if (self = [super init]) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.screenSize = [UIScreen mainScreen].bounds.size;
        self.headHeight = headHeight;
        self.segmentHeight = segmentHeight;
        self.recordOffsetArray = @[@(0), @(0), @(0)].mutableCopy;
        self.headHeight = headHeight;
        self.segmentHeight = segmentHeight;
        self.contentControllerArray = contentControllerArray;
        self.wholeTopViewHeight = headHeight + segmentHeight;
        self.currentOffsetY = 0;
        self.currentPage = 0;
        self.currentScrollView = contentControllerArray[0].contentScrollView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height);
        scrollView.contentSize = CGSizeMake(self.screenSize.width, self.headHeight + self.screenSize.height);
        if (@available(iOS 11, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
            self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
        }
        [self.view addSubview:(_scrollView = scrollView)];
        
        UIView *wholeTopView = [UIView new];
        wholeTopView.frame = CGRectMake(0, 0, self.screenSize.width, self.wholeTopViewHeight);
        headView.frame = CGRectMake(0, 0, self.screenSize.width, headHeight);
        segmentView.frame = CGRectMake(0, headHeight, self.screenSize.width, segmentHeight);
        [wholeTopView addSubview:(_headView = headView)];
        [wholeTopView addSubview:(_segmentView = segmentView)];
        [self.scrollView addSubview:(_wholeTopView = wholeTopView)];
        
        for (ContentController *contentController in contentControllerArray) {
            contentController.mainScrollView = self.scrollView;
            contentController.mainScrollViewMaxOffsetY = self.headHeight;
        }
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.screenSize.width, self.screenSize.height-self.segmentHeight);
        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.wholeTopViewHeight, self.screenSize.width, self.screenSize.height-self.segmentHeight) collectionViewLayout:layout];
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.delegate = (id<UICollectionViewDelegate>)self;
        collectionView.bounces = NO;
        [collectionView registerClass:[_CollectionPageCell class] forCellWithReuseIdentifier:@"_CollectionPageCell"];
        [self.scrollView addSubview:(_collectionView = collectionView)];
    }
    return self;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.headView.frame = CGRectMake(0, 0, self.screenSize.width, self.headHeight);
    self.segmentView.frame = CGRectMake(0, self.headHeight, self.screenSize.width, self.segmentHeight);
}

- (void)loadView{
    self.view = [[MainControllerView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Public
- (void)userBeginTapOrDrag:(CGPoint)point{
    CGPoint pointInScrollView = [self.view convertPoint:point toView:self.scrollView];
    if (CGRectContainsPoint(self.wholeTopView.frame, pointInScrollView)) {
        [self.wholeTopView addGestureRecognizer:self.currentScrollView.panGestureRecognizer];
    }else{
        [self.currentScrollView addGestureRecognizer:self.currentScrollView.panGestureRecognizer];
    }
}

#pragma mark - Private
- (void)adjustScrollView{
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat minus = offsetY - self.currentOffsetY;
    if (minus > 0) {//drag up
        if (offsetY > self.headHeight) {
            self.scrollView.contentOffset = CGPointMake(0, self.headHeight);
            offsetY = self.headHeight;
        }
    }else{//drag down
        if (self.currentScrollView.contentOffset.y > 0) {
            self.scrollView.contentOffset = CGPointMake(0, self.currentOffsetY);
            offsetY = self.currentOffsetY;
        }
    }
    self.currentOffsetY = offsetY;
}

- (void)changePage{
    NSInteger currentPage = (NSInteger)(self.collectionView.contentOffset.x / self.screenSize.width + 0.5);
    self.currentPage = currentPage;
}

- (void)changeWholeTopFrame{
    CGFloat offset = self.scrollView.contentOffset.y;
    if (offset < 0) {
        CGFloat wholeTopHeight = self.wholeTopViewHeight-offset;
        self.wholeTopView.frame = CGRectMake(0, offset, self.screenSize.width, wholeTopHeight);
        CGFloat headHeight = wholeTopHeight - self.segmentHeight;
        self.headView.frame = CGRectMake(0, 0, self.screenSize.width, headHeight);
        self.segmentView.frame = CGRectMake(0, headHeight, self.screenSize.width, self.segmentHeight);
    }else{
        self.wholeTopView.frame = CGRectMake(0, 0, self.screenSize.width, self.wholeTopViewHeight);
        self.headView.frame = CGRectMake(0, 0, self.screenSize.width, self.headHeight);
        self.segmentView.frame = CGRectMake(0, self.headHeight, self.screenSize.width, self.segmentHeight);
    }
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
        controller.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:controller];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if (_currentPage == currentPage) {
        return;
    }
    if ([self.contentControllerArray[currentPage] isKindOfClass:[ContentController class]]) {
        self.currentScrollView = self.contentControllerArray[currentPage].contentScrollView;
    }else{
        self.currentScrollView = nil;
    }
    _currentPage = currentPage;
}

#pragma mark - UICollection代理及数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentControllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    _CollectionPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_CollectionPageCell" forIndexPath:indexPath];
    cell.controllerView = self.contentControllerArray[indexPath.row].view;
    return cell;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self adjustScrollView];
        [self changeWholeTopFrame];
    }else if (scrollView == self.collectionView){
        [self changePage];
    }
}

@end
