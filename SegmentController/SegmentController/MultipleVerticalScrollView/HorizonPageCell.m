//
//  HorizonPageCell.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "HorizonPageCell.h"
#import "PageCell.h"

@interface HorizonPageCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *pageCollectionView;

@end

@implementation HorizonPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configView];
    }
    return self;
}

- (void)configView{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"[%@][%s]", NSStringFromClass([self class]), sel_getName(_cmd));
    self.pageCollectionView.frame = self.contentView.bounds;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.pageCollectionView.collectionViewLayout;
    layout.itemSize = self.pageCollectionView.bounds.size;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.controllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PageCell *pageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PageCell" forIndexPath:indexPath];
    pageCell.childControllerView = self.controllerArray[indexPath.row].view;
    return pageCell;
}

#pragma mark - Getter
- (UICollectionView *)pageCollectionView{
    if (_pageCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        pageCollectionView.pagingEnabled = YES;
        pageCollectionView.backgroundColor = [UIColor whiteColor];
        pageCollectionView.dataSource = self;
        pageCollectionView.delegate = self;
        [pageCollectionView registerClass:[PageCell class] forCellWithReuseIdentifier:@"PageCell"];
        [self.contentView addSubview:(_pageCollectionView = pageCollectionView)];
    }
    return _pageCollectionView;
}

#pragma mark - Setter
- (void)setControllerArray:(NSArray<UIViewController *> *)controllerArray{
    _controllerArray = controllerArray;
    [self.pageCollectionView reloadData];
}

@end
