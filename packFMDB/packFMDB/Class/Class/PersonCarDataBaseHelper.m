//
//  PersonCarDataBaseHelper.m
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "PersonCarDataBaseHelper.h"
#import "People.h"
#import "FMDBHelp.h"
#import "Car.h"

@implementation PersonCarDataBaseHelper

+(instancetype)shareInstance {
    static PersonCarDataBaseHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[PersonCarDataBaseHelper alloc]init];
        [helper initDataBase];
    });
    return helper;
}

- (void)addPerson:(People *)people {
    
    //--------------------
//    [[FMDBHelp shareInstance] insert:people tableName:@"person"]; // 参考HDF的封装
    //--------------------
    
    [[FMDBHelp shareInstance].dataBase open];
    
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [[FMDBHelp shareInstance].dataBase executeQuery:@"SELECT * FROM person "];
    //获取数据库中最大的ID
    while ([res next]) { // 第一次循环没有next,不会走进去这个判断,maxID就是1 这个循环的作用就是拿到最后一个person_id,再加一,往后添加
        if ([maxID integerValue] < [[res stringForColumn:@"person_id"] integerValue]) { //  [res stringForColumn:@"person_id"]第一次是nil
            maxID = @([[res stringForColumn:@"person_id"] integerValue] ) ; // 如果maxID比personId小,就让maxID = personID  person_id从1开始的?
        }
    }
    maxID = @([maxID integerValue] + 1);
    
    [[FMDBHelp shareInstance].dataBase executeUpdate:@"INSERT INTO person(person_id,person_name,person_age,person_updateTime)VALUES(?,?,?,?)",maxID,people.name,@(people.age),@(0)];
    
    [[FMDBHelp shareInstance].dataBase close];
}

/**增加车*/
- (void)addCar:(Car *)car toPerson:(People *)person {
    FMDatabase *db = [FMDBHelp shareInstance].dataBase;
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM car WHERE own_id = %@",person.ID];
    FMResultSet *resultSet = [db executeQuery:sql];
    NSInteger maxID = 0;
    while ([resultSet next]) { // while 写成了 if 循环就走一次,造成carID是相同
        if (maxID < [resultSet stringForColumn:@"car_id"].integerValue) {
            maxID = [resultSet stringForColumn:@"car_id"].integerValue;
        }
    }
    maxID = maxID + 1;
//    NSNumber *max = [NSNumber numberWithInteger:maxID];
    [db executeUpdate:@"INSERT INTO car(own_id,car_id,car_brand,car_price)VALUES(?,?,?,?)",person.ID,@(maxID),car.brand,@(car.price)]; // own_id == person_id car_id == maxID
    // maxID递增,car_id也递增  car_id作用类似person_id
    [db close];
}

- (NSMutableArray *)getPersonArray {
    NSArray *arr = [[FMDBHelp shareInstance] queryWithSql:@"SELECT * FROM person"];
    NSMutableArray *resultArr = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        People *person = [[People alloc]init];
        person.name = [dict objectForKey:@"person_name"];
        person.age = [[dict objectForKey:@"person_age"] integerValue];
        person.ID = [dict objectForKey:@"person_id"]; // person_id-->maxID-->person.ID
        person.updateTime = [[dict objectForKey:@"person_updateTime"] integerValue];
        [resultArr addObject:person];
    }
    return resultArr;
}

- (NSMutableArray *)getCarFromPerson:(People *)person {
    NSMutableArray *carArr = [NSMutableArray array];
    // 打开数据库 查询得到数组 转成模型 直接执行不行,要传参数
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM car WHERE own_id = %@",person.ID];
    
    NSArray *carArrDict = [NSArray arrayWithArray:[[FMDBHelp shareInstance] queryWithSql:sql]];

    for (NSDictionary *dict in carArrDict) {
        Car *car = [[Car alloc]init];
        car.brand = [dict objectForKey:@"car_brand"];
        car.price = [[dict objectForKey:@"car_price"] integerValue];
        car.own_id = person.ID;
        car.car_id = [dict objectForKey:@"car_id"]; // 取值
        [carArr addObject:car];
    }
    
    return carArr;
}

- (void)initDataBase {
    [[FMDBHelp shareInstance] createDBWithName:@"dataBasedemo"];
    [[FMDBHelp shareInstance] queryWithSql:@"CREATE TABLE 'person' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'person_id' VARCHAR(255),'person_name' VARCHAR(255),'person_age' VARCHAR(255),'person_updateTime' VARCHAR(255)) "]; // person_number'VARCHAR(255)没加
    [[FMDBHelp shareInstance] queryWithSql:@"CREATE TABLE 'car' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'car_id' VARCHAR(255),'car_brand' VARCHAR(255),'car_price'VARCHAR(255)) "];
    NSLog(@"homeDictionaryPath-->-- %@",NSHomeDirectory());
}

- (void)deletePerson:(People *)person {
//    NSString *sql = [NSString stringWithFormat:@"DELETE FROM person WHERE person_id = ?%@",person.ID];
//    [[FMDBHelp shareInstance] queryWithSql:sql];
    // 打开
    [[FMDBHelp shareInstance].dataBase open];
    // 执行
    [[FMDBHelp shareInstance].dataBase executeUpdate:@"DELETE FROM person WHERE person_id = ?", person.ID]; // executeQuery不行
    // 关闭
    [[FMDBHelp shareInstance].dataBase close];
    
}

- (void)deletCar:(Car *)car owner:(People *)person {
    FMDatabase *db = [FMDBHelp shareInstance].dataBase;
    [db open];
    // 删除 person_id 两个条件
    [db executeUpdate:@"DELETE FROM car WHERE own_id = ? and car_id = ?",person.ID,car.car_id]; // 应该用person_id??? delete没有* select有*
    
    [db close];
}

- (void)updatePerson:(People *)people {
    FMDatabase *db = [FMDBHelp shareInstance].dataBase;
    [db open];
    NSNumber *updateNum = @(people.updateTime + 1);
    [db executeUpdate:@"UPDATE 'person' SET person_updateTime = ? WHERE person_id = ?", updateNum, people.ID]; // sql语句后面的参数 可以传什么类型的
//    [db executeUpdate:@"UPDATE 'person' SEL person_name = ? WHERE person_id = ?",people.name, people.ID]; // 全部要更新么?只更新一条行么?
    [db executeUpdate:@"UPDATE 'person' SET person_age = ? WHERE person_id = ?", @(people.age),people.ID];
    [db close];
}

- (NSMutableArray *)queryTwoTable {
    NSMutableArray *arrMu = [NSMutableArray array];
    
    NSString *sql = @"SELECT person.person_name,car.id,car.car_brand  FROM car,person where car.own_id = person.id  and person.id=1";
    arrMu = [[[FMDBHelp shareInstance]queryWithSql:sql] copy];
    return arrMu;
}

@end

