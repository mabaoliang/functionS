//
//  FunctionKeyBoard.m
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import "FunctionKeyBoard.h"

@implementation FunctionKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadModle];
    }
    return self;
}

- (void)loadModle
{
// 需要添加相关功能组件
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 40, 40);
    [btn setTitle:@"图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tapFuncBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)tapFuncBtn:(UIButton *)btn
{
    if (self.tapFuncBtnTag) {
        self.tapFuncBtnTag(btn.tag);
    }
}

@end
