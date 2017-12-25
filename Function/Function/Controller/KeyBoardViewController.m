//
//  KeyBoardViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/25.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "KeyBoardViewController.h"
#import "ToolView.h"
#import "SDHeader.h"
@interface KeyBoardViewController ()
@property (strong, nonatomic) ToolView * toolView;
@end

@implementation KeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.toolView];
    
    // Do any additional setup after loading the view.
}

-(ToolView *)toolView
{
    if (!_toolView) {
       _toolView = [[ToolView alloc]initWithFrame:CGRectMake(0, SDDeviceHeight-40, SDDeviceWidth, 40)];
        //  self.toolView.translatesAutoresizingMaskIntoConstraints = NO;
        _toolView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:self.toolView];
        __weak typeof(self) copy_self=self;
        //点击工具按钮
        _toolView.toolViewFuncBlock = ^(FuncKeyBoardBtnTag tag){
            switch (tag) {
                case FuncKeyBoardBtnImage:
                {
                    NSLog(@"点击图片");
                    //[copy_self showDetailViewController:copy_self.picker sender:nil];
                    break;
                }
                case FuncKeyBoardBtnCamera:
                {
                    NSLog(@"选择相机");
                    break;
                }
                case FuncKeyBoardBtnLcation:
                {
                    NSLog(@"选择地图");
                    break;
                }
                case FuncKeyBoardBtnMoney:
                {
                    NSLog(@"选择红包");
                    break;
                }
                default:
                    break;
                    
                    
            }
            [copy_self.toolView resignFirstResponder];
            if (copy_self.toolView.changeToolViewHeight) {
                copy_self.toolView.changeToolViewHeight(40);
            }
            
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:nil];
        };
      
        //更改toolView高度
        self.toolView.changeToolViewHeight = ^(CGFloat height){
            if (ceil(height) > 30) {
                // layout.constant = height;
            }
            
        };
        
        //发送文本
        self.toolView.sendMessageBlock = ^(NSString * text){
            NSLog(@"文本");
            
            // copy_self.label.attributedText = [copy_self convertStringToAttributedStringWithString:text];
        };
        
        //发送语音
        self.toolView.sendVoiceBlock = ^(NSURL * url){
            NSLog(@"voiceUrl = %@",url);
            //copy_self.url = url;
        };
        
        
        
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(recieveNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
     
        

    }
    return _toolView;
}
- (void)recieveNoti:(NSNotification *)noti
{
    NSDictionary *dic=noti.userInfo;
    NSValue * value = dic[UIKeyboardFrameEndUserInfoKey];
    CGRect f = [value CGRectValue];
    CGRect frame=self.view.frame;
    if (f.origin.y==SDDeviceHeight)
    {
        frame.origin.y=0;
    }
    else
    {
        frame.origin.y=-f.size.height;
    }
    self.view.frame=frame;
    //[self.view layoutIfNeeded];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
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
