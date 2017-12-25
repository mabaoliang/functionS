//
//  ToolView.m
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import "ToolView.h"
#import "ClearView.h"
#import <AVFoundation/AVFoundation.h>
#define SCREEN_SIZE [[UIScreen mainScreen]bounds].size

@interface ToolView ()<MyTextViewDelegate>
@property (strong, nonatomic) MyTextView * textView;
@property (strong, nonatomic) UIButton * voiceBtn;
@property (strong, nonatomic) UIButton * faceBtn;
@property (strong, nonatomic) UIButton * funcBtn;
@property (strong, nonatomic) UIButton * recordBtn;

@property (strong, nonatomic) UIButton * SpeakButton;
@property (strong, nonatomic) UIButton * RecordBtton;
@property (strong, nonatomic) UIButton * FunctionButton;
@property (strong, nonatomic) UIButton * FaceButton;
@property (strong, nonatomic) ClearView * clearV;
@property (nonatomic ,strong)AVAudioRecorder * audioRecorder;

@end

@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadModule];
//        [self setUpModule];
    }
    return self;
}

- (void)loadModule
{
    self.textView = [[MyTextView alloc]initWithFrame:CGRectZero];
    self.textView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    __weak __block typeof(self) copy_self = self;
    //发送文本
    self.textView.textViewSendBlock = ^(NSString * text){
        if (copy_self.sendMessageBlock) {
            copy_self.sendMessageBlock(text);
            copy_self.textView.text = nil;
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":copy_self.textView}];
        }
    };
    //更改toolView高度
    self.textView.toolViewChangeHeight = ^(CGFloat height){
        if (copy_self.changeToolViewHeight) {
            copy_self.changeToolViewHeight(height);
        }
    };
    
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice.png"] forState:UIControlStateNormal];
    self.voiceBtn.tag = KeyBoardModeRecord;
    self.voiceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.voiceBtn addTarget:self action:@selector(tapVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voiceBtn];
    
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceBtn setImage:[UIImage imageNamed:@"ToolViewEmotion.png"] forState:UIControlStateNormal];
    self.faceBtn.tag = KeyBoardModeFace;
    self.faceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.faceBtn addTarget:self action:@selector(tapFaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.faceBtn];
    
    self.funcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.funcBtn setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black.png"] forState:UIControlStateNormal];
    self.funcBtn.tag = KeyBoardModeFunc;
    self.funcBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.funcBtn addTarget:self action:@selector(tapFuncButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.funcBtn];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    self.recordBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.recordBtn.backgroundColor = [UIColor grayColor];
    self.recordBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordBtn addTarget:self action:@selector(tapRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    self.recordBtn.layer.cornerRadius = 5;
    [self addSubview:self.recordBtn];
    //为record按钮添加长按手势
    UILongPressGestureRecognizer * longG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecordButton:)];
    longG.minimumPressDuration = 1;
    [self.recordBtn addGestureRecognizer:longG];
    
    NSDictionary * dic = NSDictionaryOfVariableBindings(_textView,_voiceBtn,_recordBtn,_faceBtn,_funcBtn);
    
    //带录音按钮水平方向
    NSString * tool_H_record = @"H:|-5-[_voiceBtn(30)]-8-[_recordBtn]-8-[_faceBtn(30)]-8-[_funcBtn(30)]-5-|";
    NSString * tool_record_V = @"V:|-5-[_recordBtn(30)]";//录音竖直方向
    //带输入框水平方向
    NSString * tool_H_textView = @"H:|-5-[_voiceBtn(30)]-8-[_textView]-8-[_faceBtn(30)]-8-[_funcBtn(30)]-5-|";
    NSString *tool_voice_V = @"V:|-5-[_voiceBtn(30)]";//voice竖直方向
    NSString *tool_textView_V = @"V:|-5-[_textView]-5-|";//输入框竖直方向
    NSString *tool_face_V = @"V:|-5-[_faceBtn(30)]";//表情竖直方向
    NSString *tool_func_V = @"V:|-5-[_funcBtn(30)]";//功能竖直方向
    
    
    //record水平方向
    NSArray * h_record = [NSLayoutConstraint constraintsWithVisualFormat:tool_H_record options:0 metrics:nil views:dic];
    [self addConstraints:h_record];
    //record竖直方向
    NSArray * v_record = [NSLayoutConstraint constraintsWithVisualFormat:tool_record_V options:0 metrics:nil views:dic];
    [self addConstraints:v_record];
    self.recordBtn.hidden = YES;//隐藏录音按钮
    //输入框水平方向
    NSArray * h_textView = [NSLayoutConstraint constraintsWithVisualFormat:tool_H_textView options:0 metrics:nil views:dic];
    [self addConstraints:h_textView];
    //voice竖直方向
    NSArray * v_voice = [NSLayoutConstraint constraintsWithVisualFormat:tool_voice_V options:0 metrics:nil views:dic];
    [self addConstraints:v_voice];
    //输入框竖直方向
    NSArray * v_textView = [NSLayoutConstraint constraintsWithVisualFormat:tool_textView_V options:0 metrics:nil views:dic];
    [self addConstraints:v_textView];
    //face竖直方向
    NSArray * v_face = [NSLayoutConstraint constraintsWithVisualFormat:tool_face_V options:0 metrics:nil views:dic];
    [self addConstraints:v_face];
    //func竖直方向
    NSArray * v_func = [NSLayoutConstraint constraintsWithVisualFormat:tool_func_V options:0 metrics:nil views:dic];
    [self addConstraints:v_func];
    
    self.clearV = [[ClearView alloc]initWithFrame:CGRectMake(43, 5, SCREEN_SIZE.width-43-81, 30)];
    self.clearV.backgroundColor = [UIColor clearColor];
    self.clearV.layer.cornerRadius = 5;
    [self addSubview:self.clearV];
    self.clearV.clearViewBlock = ^(){
        [copy_self changeToolViewNormal];
        [copy_self.textView changeKeyBoardWithMode:KeyBoardModeSystem];
    };
    
    //初始化录音机
    [self loadRecord];
    
}

- (void)myTextView:(MyTextView *)mtv didTapFuncBtn:(FuncKeyBoardBtnTag)tag
{
    if (self.toolViewFuncBlock)
    {
        self.toolViewFuncBlock(tag);
    }
}

#pragma mark toolView按钮
//语音按钮
- (void)tapVoiceButton:(UIButton *)voiceBtn
{
    if (voiceBtn.tag == KeyBoardModeRecord)
    {
        [self changeToolViewNormal];
        self.voiceBtn.tag = KeyBoardModeSystem;
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard.png"] forState:UIControlStateNormal];
        [self.textView resignFirstResponder];
        //self.textView.hidden = YES;
        //self.recordBtn.hidden = NO;
        if (self.changeToolViewHeight) {
            self.changeToolViewHeight(40);
        }
    }else
    {
        [self changeToolViewNormal];
        [self.textView changeKeyBoardWithMode:KeyBoardModeSystem];
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":self.textView}];
        
    }
    
}
//表情按钮
- (void)tapFaceButton:(UIButton *)faceBtn
{
    if (faceBtn.tag == KeyBoardModeFace)
    {
        [self changeToolViewNormal];
        self.clearV.hidden = NO;
        self.faceBtn.tag = KeyBoardModeSystem;
        [self.faceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard.png"] forState:UIControlStateNormal];
        [self.textView changeKeyBoardWithMode:KeyBoardModeFace];
    }else
    {
        [self changeToolViewNormal];
        [self.textView changeKeyBoardWithMode:KeyBoardModeSystem];
        //NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
       // [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":self.textView}];
    }
}
//功能按钮
- (void)tapFuncButton:(UIButton *)funcBtn
{
    if (funcBtn.tag == KeyBoardModeFunc)
    {
        [self changeToolViewNormal];
        self.clearV.hidden = NO;
        self.funcBtn.tag = KeyBoardModeSystem;
        [self.funcBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard.png"] forState:UIControlStateNormal];
        [self .textView changeKeyBoardWithMode:KeyBoardModeFunc];
    }else
    {
        [self changeToolViewNormal];
        [self.textView changeKeyBoardWithMode:KeyBoardModeSystem];
       // NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
       // [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":self.textView}];
    }
}
//录音按钮（长按手势）
- (void)tapRecordButton:(UILongPressGestureRecognizer *)longG
{
    if (longG.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"开始录音");
        [self.audioRecorder record];
    }else if (longG.state == UIGestureRecognizerStateEnded)
    {
        [self.audioRecorder stop];
        if (self.sendVoiceBlock) {
            self.sendVoiceBlock(self.audioRecorder.url);
        }
        
    }
}

//让ToolView样式恢复默认
- (void)changeToolViewNormal
{
    self.clearV.hidden = YES;
    
    self.voiceBtn.tag = KeyBoardModeRecord;
    [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice.png"] forState:UIControlStateNormal];
    
    self.textView.hidden = NO;
    self.recordBtn.hidden = YES;
    
    self.faceBtn.tag = KeyBoardModeFace;
    [self.faceBtn setImage:[UIImage imageNamed:@"ToolViewEmotion.png"] forState:UIControlStateNormal];
    
    self.funcBtn.tag = KeyBoardModeFunc;
    [self.funcBtn setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black.png"] forState:UIControlStateNormal];
}

#pragma mark MyTextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":textView}];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![textView.text isEqualToString:@""])
    {
        if ([text isEqualToString:@"\n"])
        {
            if (self.sendMessageBlock) {
                self.sendMessageBlock(self.textView.text);
                self.textView.text = nil;
                NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"MyTextViewContentDidChange" object:nil userInfo:@{@"content":textView}];
            }
            return NO;
        }
    }
    
    return YES;
}

//配置录音机
- (void)loadRecord
{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [session setActive:YES error:nil];
    
    //沙盒路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingString:@"myRecorder.caf"];
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    
    NSError * error;
    
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:path] settings:dicM error:&error];
    
    if (!error) {
        //让录音机准备录音
        [self.audioRecorder prepareToRecord];
        
    }else{
        NSLog(@"录音机初始化失败");
        NSLog(@"error = %@",error.debugDescription);
    }
}

- (void)dealloc
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


@end
