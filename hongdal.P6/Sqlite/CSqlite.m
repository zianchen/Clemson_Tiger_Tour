//
//  CSqlite.m
//  WXS
//
//  Created by zili zhu on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CSqlite.h"

@implementation CSqlite

-(void)openSqlite
{
    NSString *sqlFile = @"gps.db";
    NSArray *cachePath= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [cachePath objectAtIndex:0];
    NSString *databasePath = [cacheDir stringByAppendingPathComponent:sqlFile];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Copy the database sql file from the resourcepath to the documentpath
    if (![fileManager fileExistsAtPath:databasePath]) {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:sqlFile];
        NSError *error;
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&error];
//        if (error != nil) {
//            NSLog(@"[Database:Error] %@", error);
//        }
    }
    
    if(sqlite3_open([databasePath cStringUsingEncoding:NSASCIIStringEncoding], &database)==SQLITE_OK)
    {
         NSLog(@"open sqlite db ok.");
    }
    else
    {
        NSLog(@"open sqlite db error!!!!!!!.");
        
    }
    
//    if (sqlite3_open([[[[NSBundle mainBundle] pathForResource:@"qxd" ofType:@"db"] retain] fileSystemRepresentation], &database)==SQLITE_OK) { 
//        NSLog(@"open sqlite db ok."); 
//    }
}

-(void)closeSqlite
{
    sqlite3_close(database);
}

-(sqlite3_stmt*)runSql:(char*)sql
{
   // char *errorMsg;
    sqlite3_stmt *statement; 
    if (sqlite3_prepare_v2(database, sql, -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok"); 
    }
    return statement;
}

-(sqlite3_stmt*)NSRunSql:(NSString*)sql
{
   // char *errorMsg;
    sqlite3_stmt *statement; 
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok 2"); 
    }
    else {
        NSLog(@"select error 2");
    }
    return statement;
}

-(BOOL)NSSendSql:(NSString*)sql
{
    char *errorMsg;
    if (sqlite3_exec(database, [sql UTF8String], 0, 0, &errorMsg)==SQLITE_OK)
    { 
        NSLog(@"send ok");
        return YES;    
    }
    else 
    {
        fprintf(stderr,"Error:  %s",  errorMsg);
        return NO;
    }
    
}

@end

