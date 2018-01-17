//
//  GenerateQrCodeViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "GenerateQrCodeViewController.h"
#import <CoreImage/CoreImage.h>
@interface GenerateQrCodeViewController ()
@property(strong,nonatomic)UIImageView *qrCodeView;
@end

@implementation GenerateQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout=0;
    [self.view addSubview:self.qrCodeView];
    
    [self Qr];
    // Do any additional setup after loading the view.
}
//创建二维码
-(void)Qr{

    //创建CIFilte(滤镜)对象
     CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜默认设置
    [filter setDefaults];
    //存放的信息
    NSString *info = @"百度一下";
    //把信息转化为NSData
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    //滤镜对象kvc存值
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    // 生成二维码图片
    CIImage *outImage = [filter outputImage];
    //将二维码图片放到视图上
    self.qrCodeView.image =[UIImage imageWithCIImage:outImage]; //[ self createNonInterpolatedUIImageFormCIImage:outImage withSize:300];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


-(UIImageView *)qrCodeView
{
    if (!_qrCodeView) {
        _qrCodeView=[[UIImageView alloc]initWithFrame:CGRectMake(200, 60, 80, 80)];
    }
    return _qrCodeView;
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
