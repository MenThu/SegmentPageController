//
//  ArticleController.m
//  SegmentController
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "ArticleController.h"

@interface ArticleController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet ContentTableView *tableView;

@end

@implementation ArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentScrollView = self.tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"article_%ld", (long)(indexPath.row)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollViewScroll];
}

@end
