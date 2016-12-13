//
//  FMDBHelp.h
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//  http://www.jianshu.com/p/dd170b1cbc3b 参考

#import <Foundation/Foundation.h>
#import "FMDB.h"

/**
 封装了FMDB的工具类
 */
@interface FMDBHelp : NSObject

@property (nonatomic, strong) FMDatabase *dataBase; //!<数据库对象

/**
 支持外界自定义数据库文件名
 
 @param dbName 自定义的数据库文件名
 */
- (void)createDBWithName:(NSString *)dbName;


/**
 没有返回结果

 @param sql sql语句
 @return YES NO
 */
- (BOOL)noResultSetWithSql:(NSString *)sql;


/**
 有返回结果

 @param sql sql
 @return 返回字典数组
 */
- (NSArray<NSDictionary *> *)queryWithSql:(NSString *)sql;

/**
 单例子

 @return FMDBHelper
 */
+(instancetype)shareInstance;

- (NSNumber *)getLastItemWithKey:(NSString *)key tableName:(NSString *)tableName;

//- (void)insertTableName:(NSString *)tableName propertyKeyArray:(NSArray *)key value:(NSString *)values;

/**
 *@brief 插入一個實體
 *@param entity -要插入的實體，含有結果值的實體，設置用
 *@return 操作成功與否
 */
- (BOOL)insert:(id)entity tableName:(NSString *)tableName;

@end
