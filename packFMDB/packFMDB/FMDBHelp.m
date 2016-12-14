//
//  FMDBHelp.m
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//

#import "FMDBHelp.h"
#import <objc/runtime.h>

#define TABLE_NAME_PREFIX @"table_"

@interface FMDBHelp ()
#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t databaseQueue;
#else
@property (nonatomic, assign) dispatch_queue_t databaseQueue;
#endif
@property (nonatomic, copy) NSString *fileName; //!<数据库文件路径

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
        helper = [[FMDBHelp alloc]init]; // self?  FMDBHelp
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
- (instancetype)init {
    if (self = [super init]) {
        self.databaseQueue = dispatch_queue_create("HDFDB action queue", NULL);
    }
    return self;
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

//- (NSNumber *)getLastItemWithKey:(NSString *)key tableName:(NSString *)tableName{
//    NSNumber *maxID = @(0);
//    FMResultSet *restSet = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ",tableName]];
//    while ([restSet next]) {
//        if ([maxID integerValue] < [[restSet stringForColumn:key] integerValue]) {
//            maxID = @([[restSet stringForColumn:key] integerValue]);
//        }
//    }
//    return maxID;
//}

//- (void)insertTableName:(NSString *)tableName propertyKeyArray:(NSArray *)key value:(NSString *)values {
//    NSMutableString *sqlcmd = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);", tableName, [key componentsJoinedByString:@","], values];
//    NSLog(@"insert 语句%@",sqlcmd);
//    [self queryWithSql:sqlcmd];
//}

- (BOOL)insert:(id)entity tableName:(NSString *)tableName
{
    BOOL ok = NO;
    FMDatabase *db = self.dataBase;
    BOOL opened = [db open];
    if (opened == NO) {
        NSLog(@"Could not open db.");
        ok = NO;
    } else {
        ok = [self insert:entity withOpenDatabase:db tableName:tableName];
    }
    
    [db close];
    return ok;
}

- (BOOL)insert:(id)entity withOpenDatabase:(FMDatabase *)database tableName:(NSString *)tableName
{
    __block BOOL ok = NO;
    dispatch_sync(self.databaseQueue, ^{
//        NSString* tableName = tableName;
        
        NSMutableArray *columns = [NSMutableArray array];
        NSMutableString* values = [NSMutableString string];
        
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([entity class], &count);
        for(int i = 0 ; i < count ; i++){
            NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            // 添加数据条的时候不能修改ID
            if ([propertyName isEqualToString:@"ID"]) continue;
            
            id value = [entity valueForKey:propertyName];
            if (value && ![value isMemberOfClass:[NSNull class]]) {
                
                [columns addObject:propertyName];
                
                value = [self quotationTransferredIfIsString:value];
                
                [values appendFormat:@"'%@',",value]; // value 需要加单引号，尤其是字符串 value；加单引号前需要对 value 中的单引号实施转义
            }
        }
        free(properties);
        
        if (values.length >= 1) {
            [values deleteCharactersInRange:NSMakeRange(values.length - 1, 1)];
        }
        
        NSMutableString *sqlcmd = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);", tableName, [columns componentsJoinedByString:@","], values];
        
        NSLog(@"insert 语句%@",sqlcmd);
        
        ok = [database executeUpdate:sqlcmd];
        
    });
    
    
    if (ok) {
        return YES;
    }else{
        return NO;
    }
}

//-(NSString*)tableNameFromEntityClass:(Class)entityClass{
//    return [NSString stringWithFormat:@"%@%@", TABLE_NAME_PREFIX, NSStringFromClass(entityClass)];
//}

/*sqlite3数据库在搜索的时候，一些特殊的字符需要进行转义， 具体的转义如下：
 /   ->    //
 '   ->    ''
 [   ->    /[
 ]   ->    /]
 %   ->    /%
 &   ->    /&
 _   ->    /_
 (   ->    /(
 )   ->    /)
 经过验证以上特殊符号只有单引号需要转译
 同时在查询语句中需要escape关键字标示转义符*/
-(id)quotationTransferredIfIsString:(id)input { // DB Error: 1 "no such column: person_957号" 报错
    if ([input isKindOfClass:[NSString class]]) {
        
        return [(NSString *)input stringByReplacingOccurrencesOfString:@"\'" withString:@"\'\'"];
    } else {
        return input;
    }
}

@end
