//
//  GravityInductionViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/5.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "GravityInductionViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface GravityInductionViewController ()
@property(strong,nonatomic)CMMotionManager *motionManager; //重力感应对象 传感器
@property(strong,nonatomic)UIDynamicAnimator *dynamicAnimator; //物理仿真 动画
@property(strong,nonatomic)UIDynamicItemBehavior *dynamicItemBehavior ;// 物理仿真行为
@property(strong,nonatomic)UIGravityBehavior *gravityBehavior; //重力行为
@property(strong,nonatomic)UICollisionBehavior *collisionBehavior;//碰撞行为
@end

@implementation GravityInductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createDynamic];
    
    [self useGyroPush];
   // [self gravity];
   // [self getGyro];
   // [self getAccelerometer];
    // Do any additional setup after loading the view.
}
//创建小球
- (void)createItem{
    int x = arc4random() % (int)self.view.frame.size.width; //随机X坐标
    int size = arc4random() % 30 + 20;//随机大小
    NSArray * imageArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 100, size, size)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:imageArray[arc4random() % imageArray.count]];
    [self.view addSubview:imageView];
    //让imageView遵循行为
    [_dynamicItemBehavior addItem:imageView];
    [_gravityBehavior addItem:imageView];
    [_collisionBehavior addItem:imageView];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeItem:)];
    [imageView addGestureRecognizer:taps];
    
    
}

//小球取消
- (void)removeItem:(UITapGestureRecognizer *)taps{
    UIView *tempViews = taps.view;
    [_dynamicItemBehavior removeItem:tempViews];
    [_gravityBehavior removeItem:tempViews];
    [_collisionBehavior removeItem:tempViews];
    [tempViews removeFromSuperview];
    
}
- (void)useGyroPush{
  
    //判断传感器是否可用
    if ([self.motionManager isDeviceMotionAvailable]) {
        ///设备 运动 更新 间隔
        self.motionManager.deviceMotionUpdateInterval = 1;
        ///启动设备运动更新队列
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                                                    double gravityX = motion.gravity.x;
                                                    double gravityY = motion.gravity.y;
                                                    // double gravityZ = motion.gravity.z;
                                                    // 获取手机的倾斜角度(z是手机与水平面的夹角， xy是手机绕自身旋转的角度)：
                                                    //double z = atan2(gravityZ,sqrtf(gravityX * gravityX + gravityY * gravityY))  ;
                                                    double xy = atan2(gravityX, gravityY); //反正切函数
                                                    // 计算相对于y轴的重力方向
                                                    _gravityBehavior.angle = xy-M_PI_2;
                                                    
                                                }];
        
    }
}

//行为创建
- (void)createDynamic
{
    //创建现实动画 设定动画模拟区间。self.view : 地球
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    //创建物理仿真行为
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    //设置弹性系数,数值越大,弹力值越大
    _dynamicItemBehavior.elasticity = 0.5;
    //重力行为
    _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
    //碰撞行为
    _collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[]];
    //开启刚体碰撞
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    //将行为添加到物理仿动画中
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
    [_dynamicAnimator addBehavior:_gravityBehavior];
    [_dynamicAnimator addBehavior:_collisionBehavior];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self createItem];
}

//懒加载对象
-(CMMotionManager *)motionManager
{
    if (!_motionManager) {
        
        _motionManager=[[CMMotionManager alloc]init];
    }
    return _motionManager;
}
//获取磁力计传感器
-(void)gravity
{
    //判断磁力计是否可用
    if (![self.motionManager isMagnetometerAvailable]) {
        
        return;
    }
    //设置采样间隔
    self.motionManager.magnetometerUpdateInterval=1.0;
    
    //开始获取
    [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        
        CMMagneticField field=magnetometerData.magneticField;
         NSLog(@"磁力计 %f,%f,%f",field.x,field.y,field.z);
    }];
}
//获取陀螺仪方法
-(void)getGyro{
    //先判断陀螺仪是否可用
    if (![self.motionManager isGyroAvailable]) {
        NSLog(@"陀螺仪不可用");
        return;
    }
    //2 设置采样间隔
    self.motionManager.gyroUpdateInterval =0.2;
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        CMRotationRate rate =    gyroData.rotationRate;
        //获取陀螺仪 三个xyz值
        NSLog(@"x:%f y:%f z:%f", rate.x, rate.y, rate.z);
    }];
    
    
}
// 获取加速计方法
-(void)getAccelerometer{
    if (![self.motionManager isAccelerometerAvailable]) {
        NSLog(@"加速计不可用");
    }
    //设置采取 时间间隔
    self.motionManager.accelerometerUpdateInterval =0.1;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        // 获取加速计信息
        CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
    }];
    
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
