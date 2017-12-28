//
//  StepGaugeViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/27.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "StepGaugeViewController.h"
#import "WLHealthKitManage.h"
@interface StepGaugeViewController ()
@property(nonatomic,strong)  UILabel *stepLabel;
@property(nonatomic,strong)UILabel *distanceLabel;
@end

@implementation StepGaugeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, 100, 100, 40);
    [btn1 setTitle:@"计步" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(onClickBtn1) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(50, 160, 100, 40);
    [btn2 setTitle:@"距离" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(onClickBtn2) forControlEvents:UIControlEventTouchUpInside];
    
    _stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 220, 200, 40)];
    _stepLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_stepLabel];
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 280, 200, 40)];
    _distanceLabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_distanceLabel];
    // Do any additional setup after loading the view.
}
- (void)onClickBtn1
{
    WLHealthKitManage *manager=[WLHealthKitManage shareInstance];
    __weak typeof(self) weakself=self;
    [manager getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
       
        weakself.stepLabel.text=[NSString stringWithFormat:@"%f",value];
        NSLog(@"步数==%f",value);
    }];
}

- (void)onClickBtn2
{
   
    
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
