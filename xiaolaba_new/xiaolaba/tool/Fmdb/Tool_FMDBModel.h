//
//  Tool_FMDBModel.h
//  FMDB封装
//
//  Created by Yang on 16/3/24.
//  Copyright © 2016年 Yang. All rights reserved.
//

/*
 1.如果一个数据模型需要进行数据库操作，那么必须继承Tool_FMDBModel，即我这么类是所有模型的父类；
 */

#import <Foundation/Foundation.h>
/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
#define SQLMODEL    @"MODEL"   //sqlite没有model这个数据类型，这只是为了与数组进行区分
#define PrimaryKey  @"primary key"

#define primaryId   @"pk"

@interface Tool_FMDBModel : NSObject
/** 主键 id */
@property (nonatomic, assign)   int        pk;
/** 列名 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeNames;
/** 列类型 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeTypes;
/**
 * 创建表(表名为类名:self.class)
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable;
/**
 *  获取该类的所有属性以及属性对应的类型
 */
+ (NSDictionary *)getPropertys;
/** 获取模型中的所有属性，并且添加一个主键字段pk。这些数据都存入一个字典中 */
+ (NSDictionary *)getAllProperties;
//取出数据库中，指定表名的所有字段名称
+ (NSArray *)getColumns;
/** 数据库中是否存在表 */
+ (BOOL)isExistInTable;


/** 保存当前用户对象 */
- (BOOL)save;
/** 应用事务批量保存用户对象 */
+ (BOOL)saveObjects:(NSArray *)array;


/** 通过条件删除数据 */
+ (BOOL)deleteObjectsByCriteria:(NSString *)criteria;
/** 清空表 */
+ (BOOL)clearTable;

/** 条件更新数据(这里的条件暂时以主键为条件，因为创建模型对象时，会给主键主动赋一个值) */
- (BOOL)update;
/** 批量更新用户对象*/
/*批量更新数据的关键是什么？关键就是数组中的模型对象怎么与数据库的数据对应起来？靠主键*/
+ (BOOL)updateObjects:(NSArray *)array;


/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria;
/** 查询全部数据 */
+ (NSMutableArray *)findAll;
//通过条件查询数据
+ (NSArray *)findByCriteria:(NSString *)criteria;
@end
