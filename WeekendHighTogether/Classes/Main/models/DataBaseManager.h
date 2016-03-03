//
//  DataBaseManager.h
//  WeekendHighTogether
//
//  Created by SCJY on 16/3/1.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
@interface DataBaseManager : NSObject
//用单例创建数据库管理对象
+ (DataBaseManager *)shareInatance;
#pragma mark------数据库基础操作
//创建数据库
- (void)createDataBase;
//创建数据库表
- (void)createDataBaseTable;
//打开数据库
- (void)openDataBase;
//关闭数据库
- (void)closeDataBase;
#pragma mark------数据库常用操作
//增
- (void)insertIntoCity:(City *)city;
//删
- (void) deleteCity;
//查
- (City *)selectAllCity;
@end
