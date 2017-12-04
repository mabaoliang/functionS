//
//  ScanQrCodeViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "ScanQrCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanQrCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(strong,nonatomic)AVCaptureSession *session;
@property(strong,nonatomic)UIBarButtonItem *rightbtn;
@property(strong,nonatomic)AVCaptureVideoPreviewLayer *layer;
@property(strong,nonatomic)UILabel *lbText; //显示扫描内容
@end

@implementation ScanQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=0;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=self.rightbtn;
    [self.view addSubview:self.lbText];
}
-(UILabel *)lbText
{
    if (!_lbText) {
        _lbText=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 100)];
        _lbText.numberOfLines=0;
    }
    return _lbText;
}
-(UIBarButtonItem *)rightbtn
{
    if (!_rightbtn) {
        _rightbtn=[[UIBarButtonItem alloc]initWithTitle:@"扫描" style:(UIBarButtonItemStyleDone) target:self action:@selector(btnWay:)];
    }
    return _rightbtn;
}
//按钮事件
-(void)btnWay:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"扫描"]) {
        
        [self initQr];
        [item setTitle:@"停止"];
    }else
    {
        [item setTitle:@"扫描"];
        //2.停止会话
        [self.session stopRunning];
        
        //3.移除预览图层
        [self.layer removeFromSuperlayer];


    }
}
//判断相机是否可用
-(void)initQr
{
    //摄像头是否可用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    
        [self sessionInit];
        
    }else{
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"相机不可用" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *canll=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:canll];
        [self presentViewController:alert animated:YES completion:^{
           [alert dismissViewControllerAnimated:YES completion:^{
               
           }];
        }];
    }
}

//初始化
-(void)sessionInit{

    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    self.session = session;
    //AVMediaTypeVideo:摄像头, AVMediaTypeAudio:话筒, AVMediaTypeMuxed:弹幕
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    //设置输出类型,必须在output 加入到会话之后来设置
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    [session startRunning];
   
   }

//调用扫面结果的代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0)
    {
        //1.获取到扫描的内容
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        
        NSLog(@"扫描的内容==%@",object.stringValue);
        _lbText.text=object.stringValue;
        //2.停止会话
        [self.session stopRunning];
        
        //3.移除预览图层
        [self.layer removeFromSuperlayer];
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
