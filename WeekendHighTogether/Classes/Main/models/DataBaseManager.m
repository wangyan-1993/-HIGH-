//
//  DataBaseManager.m
//  WeekendHighTogether
//
//  Created by SCJY on 16/3/1.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DataBaseManager.h"
//引入数据库头文件
#import <sqlite3.h>


@interface DataBaseManager()
{
    NSString *dataBasePath;//数据库创建路径
}
@end

@implementation DataBaseManager
//创建一个静态的单例对象（DataBaseManager）,设置初始值为空
static DataBaseManager *dbManager = nil;
+ (DataBaseManager *)shareInatance{
    //如果单例对象为空，就去创建一个
    if (dbManager == nil) {
        dbManager =[[DataBaseManager alloc]init];
    }
    return dbManager;
}
#pragma mark------数据库基础操作
//创建一个静态数据库实例对象
static sqlite3 *dataBase = nil;

//创建数据库
- (void)createDataBase{
    //获取应用程序沙盒路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    dataBasePath = [documentPath stringByAppendingPathComponent:@"/Mango.sqlite"];
    NSLog(@"%@", dataBasePath);
}


//打开数据库
- (void)openDataBase{
    //如果数据库存在就直接返回，如果不存在就去创建一个新的数据库和表
    if (dataBase != nil) {
        return;
    }
    //创建数据库
    [self createDataBase];
    
    //第一个参数  数据库文件路径名  注意是UTF8String编码格式
    //第二个参数  数据库对象的地址
    //如果数据库文件已经存在，就是打开操作，如果数据库文件不存在，则先创建后打开
    int result = sqlite3_open([dataBasePath UTF8String], &dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //数据库打开成功之后去创建数据库表
        [self createDataBaseTable];
    }else{
        NSLog(@"数据库打开失败");
    }
}


//创建数据库表
- (void)createDataBaseTable{
    //建表语句
    NSString *sql = @"create table Citys (name text not null, cityID text not null)";
    //执行SQL语句
    /*
     第一个参数：数据库
     第二个参数：sql语句，UTF8String编码格式
     第三个参数：sqlites_callBack是函数回调，当这条语句执行完之后会调用你提供的函数，可以是NULL
     第四个参数：是你提供的指针变量，这个参数最终会传到你的回调函数中，也可以为NULL
     第五个参数：是错误信息，需要注意是指针类型，接收sqlite3执行的错误信息， 也可以为null
     */
    char *error = nil;
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &error);
    
}



//关闭数据库
- (void)closeDataBase{
    int result = sqlite3_close(dataBase);
    if (result == SQLITE_OK) {
        NSLog(@"关闭成功");
        dataBase = nil;
    }else{
        NSLog(@"关闭失败");
    }
}
//插入一个新的联系人
- (void)insertIntoCity:(City *)city{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    //sql语句
    NSString *sql = @"insert Into Citys (name, cityID) values (?, ?)";
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //绑定name
        sqlite3_bind_text(stmt, 1, [city.name UTF8String], -1, NULL);
        //绑定id
        sqlite3_bind_text(stmt, 2, [city.cityID UTF8String], -1, NULL);
        //执行
        sqlite3_step(stmt);
        
    } else {
        WYLog(@"sql语句有问题");
    }
    //删除释放掉
    sqlite3_finalize(stmt);
}
- (void)deleteCity{
    [self openDataBase];
    //创建一个存储sql语句的变量
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"delete *from Citys";
    //验证sql语句
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    //释放
    sqlite3_finalize(stmt);

}

//查询所有联系人
- (City *)selectAllCity{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"select *from Citys";
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    City *city = [[City alloc]init];
    if (result == SQLITE_OK) {
       
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString *cityID = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            city.name = name;
            city.cityID = cityID;
            
        }
    }
    else{
        NSLog(@"获取失败");
        
    }
    sqlite3_finalize(stmt);
    return city;
}


@end
