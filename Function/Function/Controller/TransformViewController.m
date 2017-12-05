//
//  TransformViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/5.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "TransformViewController.h"

@interface TransformViewController ()
@property (weak, nonatomic) IBOutlet UILabel *translationLB; //平移
@property (weak, nonatomic) IBOutlet UILabel *zoomLB; //缩放
@property (weak, nonatomic) IBOutlet UILabel *rotationLB; // 旋转

@end

@implementation TransformViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       self = [storyboard instantiateViewControllerWithIdentifier:@"TransformViewController"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taoGestureWay:)];
   
    //添加手势
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
//手势点击方法
-(void)taoGestureWay:(UITapGestureRecognizer *)tap
{
    //__weak typeof(self) weakself=self;
    /**
    [UIView animateWithDuration:1.0 animations:^{
        //不累加的变化
        self.translationLB.transform=CGAffineTransformMakeTranslation(20, 20); //平移
        
        self.zoomLB.transform=CGAffineTransformMakeScale(2, 1.5); //缩放
        
        self.rotationLB.transform=CGAffineTransformMakeRotation(M_PI_2); //旋转
    } completion:^(BOOL finished) {
        
        //还原
        [UIView animateWithDuration:0.5 animations:^{
            self.translationLB.transform=CGAffineTransformIdentity;
            self.zoomLB.transform=CGAffineTransformIdentity;
            self.rotationLB.transform  =CGAffineTransformIdentity;
        }];
    }];
    */
    //累加变化
    [UIView animateWithDuration:1.0 animations:^{
        
        self.translationLB.transform=CGAffineTransformTranslate(self.translationLB.transform, 10, 10); //累加平移
        self.zoomLB.transform=CGAffineTransformScale(self.zoomLB.transform, 1.5, 1.5); //累加缩放
        self.rotationLB.transform=CGAffineTransformRotate(self.rotationLB.transform, M_PI_2); //累加旋转
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
