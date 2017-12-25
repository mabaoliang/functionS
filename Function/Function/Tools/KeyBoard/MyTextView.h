//
//  MyTextView.h
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceKeyBorad.h"
#import "FunctionKeyBoard.h"

typedef void(^TextViewSendMessage)(NSString * text);
typedef void(^TextViewChangeToolViewHeight)(CGFloat height);

typedef NS_ENUM(NSInteger,KeyBoardMode) {
    KeyBoardModeSystem,
    KeyBoardModeFace,
    KeyBoardModeFunc,
    KeyBoardModeRecord
};

@class MyTextView;
@protocol MyTextViewDelegate;

@interface MyTextView : UITextView

@property (strong, nonatomic) TextViewSendMessage textViewSendBlock;
@property (strong, nonatomic) TextViewChangeToolViewHeight toolViewChangeHeight;

@property (weak, nonatomic) id<MyTextViewDelegate> delegate;

- (void)changeKeyBoardWithMode:(KeyBoardMode)mode;
@end

@protocol MyTextViewDelegate <UITextViewDelegate>

@optional

//使用此方法继续向上传递事件
- (void)myTextView:(MyTextView *)mtv didTapFuncBtn:(FuncKeyBoardBtnTag)tag;

@end
