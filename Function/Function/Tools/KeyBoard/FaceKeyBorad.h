//
//  FaceKeyBorad.h
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FaceSendMessage)(void);
typedef void(^FaceKeyBoardDeleteStr)(void);
typedef void(^FaceKeyBoardChangeToolViewHeight)(CGFloat height);

@protocol FaceKeyBoradDataSource;
@protocol FaceKeyBoardDelegate;


@interface FaceKeyBorad : UIView

@property (strong, nonatomic) FaceSendMessage faceSendMessage;
@property (strong, nonatomic) FaceKeyBoardDeleteStr faceDeleteStr;
@property (strong, nonatomic) FaceKeyBoardChangeToolViewHeight changeToolViewHeight;

@property (weak, nonatomic) id<FaceKeyBoardDelegate>delegate;
@property (weak, nonatomic) id<FaceKeyBoradDataSource>dataSource;
@end


@protocol FaceKeyBoardDelegate <NSObject>

@optional

//当表情按钮被点击时调用
- (void)faceKeyBoard:(FaceKeyBorad *)faceKB didTapFaceItemAtIndex:(NSInteger)index;

@end

@protocol FaceKeyBoradDataSource <NSObject>

@required

//1、有多少表情需要展示
- (NSInteger)numberOfFaceItemInFaceKeyBoard:(FaceKeyBorad *)faceKb;

//2、为kb上的按钮提供图片
- (UIImage *)faceKeyBoard:(FaceKeyBorad *)faceKB faceButtonWithFaceItemAtIndex:(NSInteger)index;

@end