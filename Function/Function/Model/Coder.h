//
//  Coder.h
//  Function
//
//  Created by 马宝亮 on 2018/1/17.
//  Copyright © 2018年 马宝亮. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^blockWay)(NSString *str);

@protocol CoderDelegate;

@interface Coder : NSObject<NSCoding>

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong)NSString *sex;
@property(assign,nonatomic)int age;
@property(weak,nonatomic )id<CoderDelegate> delegate;
-(void)blockTestWay:(void(^)(int g)) block;  //block
-(void)blockTestFun:(blockWay) bk; //block
@end

//委托代理
@protocol CoderDelegate<NSObject>

-(void)coderTestway;
@end

