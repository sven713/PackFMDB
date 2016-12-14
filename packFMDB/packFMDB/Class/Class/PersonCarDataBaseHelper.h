//
//  PersonCarDataBaseHelper.h
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class People;
@class Car;

/**
 人车数据库工具类
 */
@interface PersonCarDataBaseHelper : NSObject

/**
 添加人物------增

 @param people 被加入的人物
 */
- (void)addPerson:(People *)people;


/**
 获取人物列表----查

 @return 人物列表数组
 */
- (NSMutableArray *)getPersonArray;

/**
 删除人物-------删

 @param person 被删除的人物
 */
- (void)deletePerson:(People *)person;


/**
 删除某人的车---删

 @param car 被删除的车
 @param person 车所属的人
 */
- (void)deletCar:(Car *)car owner:(People *)person;

/**
 向某人添加小车----增

 @param car 新添加小车
 @param person 车主
 */
- (void)addCar:(Car *)car toPerson:(People *)person;


/**
 查询某人拥有的车-----查
 @param person 谁的车
 */
- (NSMutableArray *)getCarFromPerson:(People *)person;


/**
 修改person模型

 @param people 被修改的person
 */
- (void)updatePerson:(People *)people;

- (NSMutableArray *)queryTwoTable;

+(instancetype)shareInstance;
@end
