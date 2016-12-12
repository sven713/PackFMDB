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
    
//    [FMDBHelp shareInstance] queryWithSql:<#(NSString *)#>; // 插入数据
}

- (NSMutableArray *)getPersonArray {
//    [FMDBHelp shareInstance] queryWithSql:<#(NSString *)#>;
    return nil;
}

- (void)initDataBase {
    [[FMDBHelp shareInstance] createDBWithName:@"dataBasedemo"];
    [[FMDBHelp shareInstance] queryWithSql:@"CREATE TABLE 'person' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'person_id' VARCHAR(255),'person_name' VARCHAR(255),'person_age' VARCHAR(255) "];
    [[FMDBHelp shareInstance] queryWithSql:@"CREATE TABLE 'car' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'own_id' VARCHAR(255),'car_id' VARCHAR(255),'car_brand' VARCHAR(255),'car_price'VARCHAR(255)) "];
    
}

@end

