//
//  TestHeadView.m
//  SegmentController
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "TestHeadView.h"

@implementation TestHeadView

+ (instancetype)loadView{
    return [[NSBundle mainBundle] loadNibNamed:@"TestHeadView" owner:self options:nil].lastObject;
}

- (IBAction)clickBtn:(UIButton *)sender {
    NSLog(@"点击了按钮");
}

@end
