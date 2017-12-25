//
//  FunctionKeyBoard.h
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FuncKeyBoardBtnTag) {
    FuncKeyBoardBtnImage,
    FuncKeyBoardBtnCamera,
    FuncKeyBoardBtnLcation,
    FuncKeyBoardBtnMoney
};

typedef void(^FuncBlock)(FuncKeyBoardBtnTag tag);

@interface FunctionKeyBoard : UIView

@property (strong, nonatomic) FuncBlock tapFuncBtnTag;

@end
