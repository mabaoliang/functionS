//
//  MyTextView.m
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import "MyTextView.h"
#import <CoreData/CoreData.h>
#import "RecentFace.h"
#import "Coredata Manger.h"

#define SCREEN_SIZE [[UIScreen mainScreen]bounds].size
@interface MyTextView ()<FaceKeyBoradDataSource,FaceKeyBoardDelegate>
@property (strong, nonatomic) FaceKeyBorad * faceKB;
@property (strong, nonatomic) FunctionKeyBoard * funcKB;
@property (strong, nonatomic) NSArray * faces;
@property (strong, nonatomic) NSManagedObjectContext * context;
@end

@implementation MyTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadModule];
    }
    return self;
}

- (void)loadModule
{
    //初始化上下文
    Coredata_Manger * manager = [Coredata_Manger shareCoreDataManager];
    self.context = manager.context;
    
    self.layer.cornerRadius = 5;
    self.font = [UIFont systemFontOfSize:15];
//    self.scrollEnabled = NO;
//    self.contentSize = CGSizeMake(SCREEN_SIZE.width-43-81, 30);
    self.textContainer.size = CGSizeMake(SCREEN_SIZE.width-43-81, 30);
    self.faces = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"]];
    self.faceKB = [[FaceKeyBorad alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 258)];
    self.faceKB.backgroundColor = [UIColor orangeColor];
    
    __weak __block typeof(self) copy_self = self;
    //发送表情
    self.faceKB.faceSendMessage = ^(){
        if (copy_self.textViewSendBlock) {
            copy_self.textViewSendBlock(copy_self.text);
        }
    };
    //删除字符
    self.faceKB.faceDeleteStr = ^(){
        NSString * message = copy_self.text;
        if (message.length > 0)
        {
            NSString * new_message = [message substringToIndex:message.length-1];
            copy_self.text = new_message;
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":new_message}];
        }
        
    };
    //更改toolView高度
    self.faceKB.changeToolViewHeight = ^(CGFloat height){
        if (copy_self.toolViewChangeHeight) {
            copy_self.toolViewChangeHeight(height);
            
        }
    };
    self.faceKB.delegate = self;
    self.faceKB.dataSource = self;
    
    self.funcKB = [[FunctionKeyBoard alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 258)];
    self.funcKB.backgroundColor = [UIColor cyanColor];
    self.funcKB.tapFuncBtnTag = ^(FuncKeyBoardBtnTag tag){
        [copy_self.delegate myTextView:copy_self didTapFuncBtn:tag];
    };
}

//根据点击不同按钮切换键盘样式
- (void)changeKeyBoardWithMode:(KeyBoardMode)mode
{
    switch (mode) {
        case KeyBoardModeSystem:
        {
            self.inputView = nil;
            break;
        }
        case KeyBoardModeFace:
        {
            self.inputView = self.faceKB;
            break;
        }
        case KeyBoardModeFunc:
        {
            self.inputView = self.funcKB;
            break;
        }
        default:
            break;
    }
    
    if (self.isFirstResponder)
    {
        [self reloadInputViews];
    }else
    {
        [self becomeFirstResponder];
    }
}

#pragma mark FaceKeyBoardDelegate
- (void)faceKeyBoard:(FaceKeyBorad *)faceKB didTapFaceItemAtIndex:(NSInteger)index
{
    //在此处将点击的表情进行保存
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([RecentFace class])];
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"faceIndex = %ld",index];
    [request setPredicate:pre];
    
    //上下文请求数据
    NSArray * list = [self.context executeFetchRequest:request error:nil];
    RecentFace * face ;
    if (list.count > 0)
    {
        face = list[0];
        face.date = [NSDate date];//更新点击时间
    }else
    {
        face = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([RecentFace class]) inManagedObjectContext:self.context];
        face.faceIndex = [NSString stringWithFormat:@"%ld",(long)index];
        face.date = [NSDate date];
    }
    
    [self.context save:nil];
    
    
    
    
    
    
    
    //展示文本
    NSDictionary * dic = self.faces[index];
    NSString * name = dic[@"chs"];
    NSMutableString * mStr = [NSMutableString stringWithString:self.text];
    [mStr appendString:name];
    self.text = mStr;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":self}];
    
    //展示图片
//    NSDictionary * dic = self.faces[index];
//    NSString * name = dic[@"png"];
//    UIImage * image = [UIImage imageNamed:name];
//    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
//    attachment.image = image;
//    NSAttributedString * attS = [NSAttributedString attributedStringWithAttachment:attachment];
//    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
//    [attStr appendAttributedString:attS];
//    self.attributedText = attStr;
}

#pragma mark FaceKeyBoardDataSource
- (NSInteger)numberOfFaceItemInFaceKeyBoard:(FaceKeyBorad *)faceKb
{
    
    return self.faces.count;
}

- (UIImage *)faceKeyBoard:(FaceKeyBorad *)faceKB faceButtonWithFaceItemAtIndex:(NSInteger)index
{
    NSDictionary * dic = self.faces[index];
    NSString * name = dic[@"png"];
    UIImage * image = [UIImage imageNamed:name];
    return image;
}

@end
