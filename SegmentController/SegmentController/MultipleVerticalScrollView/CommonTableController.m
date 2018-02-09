//
//  CommonTableController.m
//  SegmentController
//
//  Created by MenThu on 2018/2/9.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "CommonTableController.h"

@interface CommonTableController ()

@end

@implementation CommonTableController

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
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (MultipleTable *)tableView{
    if (_tableView == nil) {
        MultipleTable *tableView = [[MultipleTable alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:(_tableView = tableView)];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSoure&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
