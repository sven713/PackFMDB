//
//  FMDBHelp.h
//  packFMDB
//
//  Created by song ximing on 2016/12/12.
//  Copyright © 2016年 song ximing. All rights reserved.
//  http://www.jianshu.com/p/dd170b1cbc3b 参考

#import <Foundation/Foundation.h>

@interface FMDBHelp : NSObject

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

///**
// 是否打开数据库成功
//
// @return YES:打开成功 NO:打开失败
// */
//- (BOOL)openOrCreateDBSuccess;


///**
// 关闭数据库
// */
//- (void)closeDB;
@end
