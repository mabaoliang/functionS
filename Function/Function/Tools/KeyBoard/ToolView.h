//
//  ToolView.h
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionKeyBoard.h"
#import "MyTextView.h"
typedef void(^ToolViewFuncBlock)(FuncKeyBoardBtnTag tag);
typedef void(^ToolViewSendMessage)(NSString * text);
typedef void(^ToolViewSendVoice)(NSURL * url);
typedef void(^ToolViewChangeHeight)(CGFloat height);

@interface ToolView : UIView
@property (strong, nonatomic) ToolViewFuncBlock toolViewFuncBlock;
@property (strong, nonatomic) ToolViewSendMessage sendMessageBlock;
@property (strong, nonatomic) ToolViewSendVoice sendVoiceBlock;
@property (strong, nonatomic) ToolViewChangeHeight changeToolViewHeight;
@end
