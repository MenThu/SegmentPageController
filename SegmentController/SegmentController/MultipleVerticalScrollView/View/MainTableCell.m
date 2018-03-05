//
//  MainTableCell.m
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "MainTableCell.h"

@interface _TempCollectionCell : UICollectionViewCell

@property (nonatomic, weak) UIView *controllerView;

@end

@implementation _TempCollectionCell

- (void)setControllerView:(UIView *)controllerView{
    if ([_controllerView isKindOfClass:[UIView class]]) {
        [_controllerView removeFromSuperview];
    }
    controllerView.frame = self.contentView.bounds;
    [self.contentView addSubview:(_controllerView = controllerView)];
}

@end

@interface MainTableCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation MainTableCell

#pragma mark - LifeCircle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configTalbeCell];
    }
    return self;
}

- (void)configTalbeCell{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
    layout.itemSize = self.contentView.bounds.size;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[_TempCollectionCell class] forCellWithReuseIdentifier:@"_TempCollectionCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.contentView addSubview:(_collectionView = collectionView)];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.collectionView.frame, self.contentView.bounds)) {
        self.collectionView.frame = self.contentView.bounds;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = self.collectionView.frame.size;
    }
}

#pragma mark - Setter
- (void)setContentControllerArray:(NSArray<ContentController *> *)contentControllerArray{
    _contentControllerArray = contentControllerArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate&DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentControllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    _TempCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"_TempCollectionCell" forIndexPath:indexPath];
    cell.controllerView = self.contentControllerArray[indexPath.row].view;
    return cell;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        if (self.changePage) {
            NSInteger currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds) + 0.5;
            NSLog(@"currentPage = [%ld]", (long)currentPage);
            self.changePage(currentPage);
        }
    }
}

@end
