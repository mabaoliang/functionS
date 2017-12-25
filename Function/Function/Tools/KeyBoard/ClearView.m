//
//  ClearView.m
//  键盘切换
//
//  Created by Augus on 16/1/6.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import "ClearView.h"

@implementation ClearView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clearViewBlock) {
        self.clearViewBlock();
    }
}

@end
