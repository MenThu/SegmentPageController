//
//  DynamicController.m
//  SegmentController
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "DynamicController.h"

@interface DynamicController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet ContentTableView *tableView;

@end

@implementation DynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentScrollView = self.tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"dynamic_%ld", (long)(indexPath.row)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollViewScroll];
}

@end
