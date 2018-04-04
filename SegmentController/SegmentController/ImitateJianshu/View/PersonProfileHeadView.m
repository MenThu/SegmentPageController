//
//  PersonProfileHeadView.m
//  SegmentController
//
//  Created by MenThu on 2018/4/4.
//  Copyright © 2018年 MenThu. All rights reserved.
//

#import "PersonProfileHeadView.h"

@implementation PersonProfileHeadView

+ (instancetype)loadView{
    return [[NSBundle mainBundle] loadNibNamed:@"PersonProfileHeadView" owner:self options:nil].lastObject;
}


- (IBAction)addFocusOrSendMail:(UIButton *)sender {
    NSString *hintMessage = @"";
    if (sender.tag == 0) {
        hintMessage = @"并不能关注";
    }else{
        hintMessage = @"并不能发送简信";
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"发生了点击事件" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alterController addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alterController animated:YES completion:nil];
}

@end
