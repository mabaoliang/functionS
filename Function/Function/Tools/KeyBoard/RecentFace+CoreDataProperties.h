//
//  RecentFace+CoreDataProperties.h
//  键盘切换
//
//  Created by Augus on 16/1/6.
//  Copyright © 2016年 刘伟华. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RecentFace.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentFace (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *faceIndex;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
