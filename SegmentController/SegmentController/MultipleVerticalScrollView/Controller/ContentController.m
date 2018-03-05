//
//  ContentController.m
//  SegmentController
//
//  Created by MenThu on 2018/3/3.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ContentController.h"
#import "ContentTableView.h"

@interface ContentController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, readwrite) ContentTableView *tableView;

@end

@implementation ContentController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    ContentTableView *tableView = [[ContentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:(_tableView = tableView)];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)sendScrollNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TableViewDidScroll" object:self.tableView];
}

#pragma mark - TableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self sendScrollNotification];
}

@end
