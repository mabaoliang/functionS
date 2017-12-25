//
//  ClearView.h
//  键盘切换
//
//  Created by Augus on 16/1/6.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearViewTapBlock)(void);

@interface ClearView : UIView
@property (strong, nonatomic) ClearViewTapBlock clearViewBlock;
@end
