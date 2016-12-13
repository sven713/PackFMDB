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
//    NSNumber *insertPosition = [[FMDBHelp shareInstance] getLastItemWithKey:@"person_id" tableName:@"person"];
//    insertPosition = @(insertPosition.integerValue + 1);
//    NSString *sql = [NSString stringWithFormat:@"INSERT INTO person(person_id,person_name,person_age)VALUES(?,?,?) %@,%@,%@",@(insertPosition.integerValue),people.name,@(people.age)]; // 要获取最大id,然后往后面插,之前封装的squl没有这个方法,加一个方法呗
//    
//    [[FMDBHelp shareInstance] queryWithSql:sql]; // 插入数据
    
//    NSArray *prepertyKeyArray = @[@"person_id",@"person_name",@"person_age"];
//    NSString *values = [NSString stringWithFormat:@"%@,%@,%@",insertPosition,people.name,@(people.age)];
//    [[FMDBHelp shareInstance] insertTableName:@"person" propertyKeyArray:prepertyKeyArray value:values];
    
    //--------------------
//    [[FMDBHelp shareInstance] insert:people tableName:@"person"]; // 参考HDF的封装
    //--------------------
    
//    [[FMDBHelp shareInstance].dataBase executeQuery:@"INSERT INTO person(person_id,person_name,person_age)VALUES(?,?,?)",insertPosition,people.name,@(people.age)];
//    
//    [[FMDBHelp shareInstance].dataBase close];
    
    
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
    
    [[FMDBHelp shareInstance].dataBase executeUpdate:@"INSERT INTO person(person_id,person_name,person_age)VALUES(?,?,?)",maxID,people.name,@(people.age)];
    
    [[FMDBHelp shareInstance].dataBase close];
}

- (NSMutableArray *)getPersonArray {
//    [FMDBHelp shareInstance] queryWithSql:<#(NSString *)#>;
//    FMDatabase *db = [FMDBHelp shareInstance].dataBase;
//    [db open]; // 打开数据库
//    NSMutableArray *modelArr = [NSMutableArray array];
//    FMResultSet

    NSArray *arr = [[FMDBHelp shareInstance] queryWithSql:@"SELECT * FROM person"];
    NSMutableArray *resultArr = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        People *person = [[People alloc]init];
        person.name = [dict objectForKey:@"person_name"];
        person.age = [[dict objectForKey:@"person_age"] integerValue];
        [resultArr addObject:person];
    }
    return resultArr;
}

- (void)initDataBase {
    [[FMDBHelp shareInstance] createDBWithName:@"dataBasedemo"];
    [[FMDBHelp shareInstance] queryWithSql:@"CREATE TABLE 'person' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'person_id' VARCHAR(255),'person_name' VARCHAR(255),'person_age' VARCHAR(255)) "]; // person_number'VARCHAR(255)没加
    [[FMDBHelp shareInstance] queryWithSql:@"CREATE TABLE 'car' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'car_id' VARCHAR(255),'car_brand' VARCHAR(255),'car_price'VARCHAR(255)) "];
    NSLog(@"homeDictionaryPath-->-- %@",NSHomeDirectory());
}

@end

