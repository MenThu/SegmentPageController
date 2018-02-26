//
//  CommonTableController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "CommonTableController.h"

NSString * const CommonTableScroll = @"CommonTableScroll";

@interface CommonTableController ()

@end

@implementation CommonTableController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    MultipleTable *tableView = [[MultipleTable alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    if (@available(iOS 11, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:(_tableView = tableView)];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSAssert(self.tableView != nil, @"scrollView不能为空");
    [[NSNotificationCenter defaultCenter] postNotificationName:CommonTableScroll object:self.tableView];
}

#pragma mark - UITableViewDataSoure&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - Getter

@end
