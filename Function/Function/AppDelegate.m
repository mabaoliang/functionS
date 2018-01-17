//
//  AppDelegate.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "AppDelegate.h"

#import "StartPageView.h"
@interface AppDelegate ()
@property(strong,nonatomic)StartPageView *startView; //启动页
 @property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;//后台任务
@property(strong,nonatomic)NSTimer *timer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [self.window makeKeyAndVisible]; //让window可见后，下面view才可以显示
    [self.window addSubview:self.startView]; //广告view
    self.window.backgroundColor=[UIColor whiteColor];
    // Override point for customization after application launch.
    return YES;
}

-(StartPageView *)startView
{
    if (!_startView) {
        
        _startView=[[StartPageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _startView;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
[ self comeToBackgroundMode];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)comeToBackgroundMode{
    
    
    //初始化一个后台任务BackgroundTask，这个后台任务的作用就是告诉系统当前app在后台有任务处理，需要时间
    UIApplication*  app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    if (!self.timer) {
        //开启定时器 不断向系统请求后台任务执行的时间
        self.timer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}

-(void)applyForMoreTime {
    //如果系统给的剩余时间小于60秒 就终止当前的后台任务，再重新初始化一个后台任务，重新让系统分配时间，这样一直循环下去，保持APP在后台一直处于active状态。
    NSLog(@"task");
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 60) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
            self.bgTask = UIBackgroundTaskInvalid;
        }];
    }
}

@end
