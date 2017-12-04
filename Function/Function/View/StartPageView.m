//
//  StartPageView.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "StartPageView.h"

NSInteger  numCount=5;
@interface StartPageView ()

@property(strong,nonatomic) UILabel *lbtitle;
@property(strong,nonatomic)UIImageView *imgView;
@end
@implementation StartPageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor blueColor];
        [self addSubview:self.imgView];
        [self addSubview:self.lbtitle];
        [self GCD];
    }
    return self;
}

//标签初始化
-(UILabel *)lbtitle
{
    if (!_lbtitle) {
        
        _lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width-10, 25)];
        _lbtitle.text=[NSString stringWithFormat:@"%ld后跳转  ",numCount];
        _lbtitle.textAlignment=NSTextAlignmentRight;
    }
    return _lbtitle;
}

//图片视图初始化
-(UIImageView *)imgView
{
    if (!_imgView) {
        _imgView=[[UIImageView alloc]initWithFrame:self.bounds];
        _imgView.image=[UIImage imageNamed:@"ggg"];
    }
    return _imgView;
}
//定时器
-(void)GCD{
 

    __block NSInteger time=numCount;
    dispatch_queue_t queque=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queque);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (time<1) {
            dispatch_source_cancel(timer); //结束定时器
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self dissmss];
            });
        }else
            
        {
            time--;
           dispatch_async(dispatch_get_main_queue(), ^{
               _lbtitle.text=[NSString stringWithFormat:@"%ld后跳转  ",time];
           });
            
        }
    });
    dispatch_resume(timer);
    
}

//动画删除view
-(void)dissmss
{
    
    __weak typeof(self) weakself=self;
 [UIView animateWithDuration:0.5 animations:^{
     
     weakself.alpha=0.0; //透明
 } completion:^(BOOL finished) {
    
     [weakself removeFromSuperview];
 }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
