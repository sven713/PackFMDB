//
//  PersonCarDataBaseHelper.h
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class People;


/**
 人车数据库工具类
 */
@interface PersonCarDataBaseHelper : NSObject

/**
 添加人物

 @param people 被加入的人物
 */
- (void)addPerson:(People *)people;


/**
 获取人物列表

 @return 人物列表数组
 */
- (NSMutableArray *)getPersonArray;
+(instancetype)shareInstance;
@end
