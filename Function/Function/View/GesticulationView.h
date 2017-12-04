//
//  GesticulationView.h
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GesticulationView;

@protocol GesticulationViewDelegate <NSObject>

-(void)lockView:(GesticulationView *)lockView pathString:(NSString *)path;

@end
@interface GesticulationView : UIView

@property(weak,nonatomic)id<GesticulationViewDelegate> delegate;
@end
