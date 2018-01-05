//
//  GraphicsView.h
//  Function
//
//  Created by 马宝亮 on 2018/1/5.
//  Copyright © 2018年 马宝亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphicsView : UIView
@property (nonatomic, assign) CGFloat zzWidth;
@property (nonatomic, assign) CGFloat zzHeight;

//画柱状图
- (void)drawZhuZhuangTu:(NSArray *)x_itemArr and:(NSArray *)y_itemArr;

//画饼形图
- (void)drawBingZhuangTu:(NSArray *)x_itemArr and:(NSArray *)y_itemArr;

//画折线图
- (void)drawZheXianTu:(NSArray *)x_itemArr and:(NSArray *)y_itemArr;
@end
