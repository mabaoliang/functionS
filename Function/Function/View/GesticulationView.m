//
//  GesticulationView.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "GesticulationView.h"
CGFloat const btnW=60.0;
CGFloat const btnH=60.0;
NSInteger const line=3;
NSInteger const btnCount=9;
#define SCREENWITHD  [UIScreen mainScreen].bounds.size.width

@interface GesticulationView ()

@property(strong,nonatomic)NSMutableArray *arrMBtn;
@property(assign,nonatomic)CGPoint currecutPonit; //当前选中的点
@end
@implementation GesticulationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor blackColor];
        [self initUI];
    }
    return self;
}

-(void)initUI{

    for (int i=0; i<btnCount; i++) {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"cicle"] forState:UIControlStateSelected];
        btn.tag=i;
        CGFloat margin=(SCREENWITHD-(btnW*line))/(line+1);
        
        NSInteger lin=i/line; //行数
        NSInteger coulmm =i% line; //列数
        
        CGFloat btnX=margin +coulmm *(btnW+margin);
        CGFloat btnY=margin+lin*(btnH+margin);
        
        btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
        btn.userInteractionEnabled=NO;
        [self addSubview:btn];
    }
    
}
-(NSMutableArray *)arrMBtn
{
    if (!_arrMBtn) {
        _arrMBtn=[NSMutableArray array];
    }
    return _arrMBtn;
}
//返回点击的点
-(CGPoint)touchGetPoint:(NSSet *)t;
{
    UITouch *th=  [t anyObject];
    CGPoint point=[th locationInView:th.view];
    return point;

}
//返回按钮
-(UIButton *)selfToBtn:(CGPoint)p
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame,p)) {
            
            return btn;
        }
    }
    return nil;
}
//手指按下
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p=[self touchGetPoint:touches];
    UIButton *btn=[self selfToBtn:p];
    
    if (btn && btn.selected==NO) {
        
        btn.selected=YES;
        
        [self.arrMBtn addObject:btn];
    }
  }
//手指移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint p=[self touchGetPoint:touches];
    UIButton *btn=[self selfToBtn:p];
    
    if (btn && btn.selected==NO) {
        
        btn.selected=YES;
         [self.arrMBtn addObject:btn];
    }else
        
    {
        self.currecutPonit=p;
    }
    [self setNeedsDisplay]; // 调用(void)drawRect:(CGRect)rect
}
//手指抬起
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([self.delegate respondsToSelector:@selector(lockView:pathString:)]) {
        
        NSMutableString *str=[NSMutableString string];
        
        for (UIButton *btn in self.arrMBtn) {
            [str appendFormat:@"%ld",(long)btn.tag];
        }
        [self.delegate lockView:self pathString:str];
    }
  //改变数组中按钮的选中状态
    for (UIButton *btn in self.subviews) {
        btn.selected=NO;
    }
    [self.arrMBtn removeAllObjects];
    [self setNeedsDisplay];
}
//意外中断
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// 画点线方法
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.arrMBtn.count==0) {
        return;
    }
    
    [[UIColor greenColor] set]; //设置线条颜色
    UIBezierPath *path=[UIBezierPath bezierPath];
    path.lineWidth=8.0; //线宽
    path.lineJoinStyle=kCGLineCapRound; //线转角样式
    for (int i=0; i<self.arrMBtn.count; i++) {
        UIButton *btn=self.arrMBtn[i];
        if (i==0) {
            [path moveToPoint:btn.center];
        }else
        {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:self.currecutPonit];
    [path stroke];
    
}


@end
