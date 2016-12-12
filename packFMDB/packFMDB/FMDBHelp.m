//
//  FMDBHelp.m
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "FMDBHelp.h"
#import "FMDB.h"

@interface FMDBHelp ()
@property (nonatomic, copy) NSString *fileName; //!<数据库文件路径
@property (nonatomic, strong) FMDatabase *dataBase; //!<数据库对象
@end

@implementation FMDBHelp

#pragma mark - public method

- (void)createDBWithName:(NSString *)dbName {
    if (dbName.length == 0) {
        self.fileName = nil;
    }else {
        if ([dbName hasSuffix:@".sqlite"]) {
            self.fileName = dbName;
        }else {
            self.fileName = [dbName stringByAppendingString:@".sqlite"];
        }
    }
}


/**无返回结果的操作*/
- (BOOL)noResultSetWithSql:(NSString *)sql {
    BOOL isOpen = [self.dataBase open];
    if (isOpen) {
        BOOL isUpdata = [self.dataBase executeUpdate:sql]; // ???????
        [self closeDB];
        return isUpdata; //
    }else {
        NSLog(@"打开数据库失败");
        [self closeDB];
        return NO;
    }
}

- (NSArray *)queryWithSql:(NSString *)sql {
    BOOL isOpen = [self openOrCreateDBSuccess];
    if (isOpen) { // 返回查询结果
        NSLog(@"打开数据库成功");
        FMResultSet *resultSet = [self.dataBase executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([resultSet next]) {
            NSDictionary *dict = [resultSet resultDictionary];
            [array addObject:dict];
        }
        [resultSet close];
        [self closeDB];
        return array;
    }else {
        NSLog(@"打开数据库失败");
        return nil;
    }
}


+(instancetype)shareInstance { // 要暴露接口么?要,不然不能调用这个方法!
    static FMDBHelp *helper = nil; // 两个static,不写static 报错
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[FMDBHelp alloc]init];
    });
    return helper;
}

#pragma mark  - private method

/**
 获取数据库文件保存路径
 */
- (NSString *)DBPath {
    if (self.fileName) {
        NSString *savePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:self.fileName];
        return savePath;
    }else {
        return @"";
    }
}

/**
 懒加载创建dataBase对象
 */
-(FMDatabase *)dataBase {
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:[self DBPath]];
    }
    return _dataBase;
}

/**
 是否打开数据库成功
 
 @return YES:打开成功 NO:打开失败
 */
- (BOOL)openOrCreateDBSuccess {
    if ([self.dataBase open]) {
        NSLog(@"打开数据库成功");
        return YES;
    }else {
        NSLog(@"打开数据库失败");
        return NO;
    }
}

/**
 关闭数据库
 */
- (void)closeDB {
    if ([self.dataBase close]) {
        NSLog(@"关闭数据库成功");
    }else {
        NSLog(@"关闭数据库失败");
    }
}



@end
