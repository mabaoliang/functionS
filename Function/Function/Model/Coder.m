//
//  Coder.m
//  Function
//
//  Created by 马宝亮 on 2018/1/17.
//  Copyright © 2018年 马宝亮. All rights reserved.
//

#import "Coder.h"

@implementation Coder


//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeInt:self.age forKey:@"age"];
}

//解当
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.sex=[aDecoder decodeObjectForKey:@"sex"];
        self.age=[aDecoder decodeIntForKey:@"age"];
    }
    return self;
    
}
@end
