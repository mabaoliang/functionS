//
//  GesticulationViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "GesticulationViewController.h"
#import "GesticulationView.h"
@interface GesticulationViewController ()<GesticulationViewDelegate>

@property(strong,nonatomic)GesticulationView *gestView;
@end

@implementation GesticulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=0;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.gestView];
    // Do any additional setup after loading the view.
}

-(GesticulationView *)gestView
{
    if (!_gestView) {
        
        _gestView=[[GesticulationView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-self.view.frame.size.width-64, self.view.frame.size.width, self.view.frame.size.width)];
        _gestView.delegate=self;
    }
    return _gestView;
}
-(void)lockView:(GesticulationView *)lockView pathString:(NSString *)path
{
    if ([path isEqualToString:@"1234"]) {
        NSLog(@"手势解锁success");
    }
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
