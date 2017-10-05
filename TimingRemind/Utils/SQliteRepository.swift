//
//  SQliteRepository.swift
//  PasswordKeeper-swift
//
//  Created by Channing on 2017/1/3.
//  Copyright © 2017年 Channing Kuo. All rights reserved.
//

import Foundation

// SQlite数据库操作类
class SQliteRepository {
    
    public static let PASSWORDINFOTABLE: String = "dataInfoTable"
    
    private static var db: SQLiteDB! = SQLiteDB.sharedInstance
    
    // 创建表
    class func createTable(tableName: String, columns: [ColumnType]) {
        var sql = "create table if not exists \(tableName)(\(tableName)Id varchar(100) not null primary key, "
        for column in columns {
            sql += "\(column.colName) \(column.colType!), "
        }
        // 最后有一个空格字符所以取  长度 - 2
        sql = sql.subString(start: 0, length: sql.characters.count - 2) + ")"
        _ = SQliteRepository.db.execute(sql: sql)
    }
    
    // 存入数据
    class func syncInsert(tableName: String, rowValue: [[ColumnType]]) -> CInt {
        var iterator: CInt = 0
        for row in rowValue {
            iterator += addOrUpdate(tableName: tableName, colValue: row)
        }
        return iterator
    }
    
    // 插入数据或更新数据   新增主键值用guid自动生成
    class func addOrUpdate(tableName: String, colValue: [ColumnType]) -> CInt {
        // 1、从colValue中获取主键对应的值
        var parimaryKeyValue = ""
        for col in colValue {
            if col.colName == tableName + "Id" {
                parimaryKeyValue = col.colValue as! String
                break
            }
        }
        // 2、根据主键和表名查询对应的数据
        //let id = checkExist(tableName: tableName, key: parimaryKeyValue)
        var id = ""
        let sql = "select \(tableName)Id from \(tableName) where \(tableName)Id = '\(parimaryKeyValue)'"
        let data = SQliteRepository.db.query(sql: sql)
        if(data.count > 0){
            let info = data[data.count - 1]
            id = info["\(tableName)Id"] as! String
        }
        // 3、根据查询结果决定新增或是更新
        if id.isEmpty {
            // Add
            var sqlAdd = "insert into \(tableName)("
            for col in colValue {
                if col.colName == "\(tableName)Id" {
                    continue
                }
                sqlAdd += "\(col.colName), "
            }
            sqlAdd += "\(tableName)Id) values("
            for col in colValue {
                if col.colName == "\(tableName)Id" {
                    continue
                }
                sqlAdd += "'\(col.colValue!)', "
            }
            let parimaryKey = id.isEmpty ? UUID().uuidString : id
            sqlAdd += "'" + parimaryKey + "')"
            return SQliteRepository.db.execute(sql: sqlAdd)
        }
        else {
            // Update
            var sqlUpdate = "update \(tableName) set "
            for col in colValue {
                if col.colName == "\(tableName)Id" {
                    continue
                }
                sqlUpdate += "\(col.colName) = '\(col.colValue!)', "
            }
            sqlUpdate = sqlUpdate.subString(start: 0, length: sqlUpdate.characters.count - 2)
            // 添加where条件
            sqlUpdate += " where \(tableName)Id = '\(id)'"
            return SQliteRepository.db.execute(sql: sqlUpdate)
        }
    }
    
    // 删除数据
    class func delete(tableName: String, columns: [ColumnType]) -> CInt {
        var sql = "delete from \(tableName) where "
        for (index,col) in columns.enumerated() {
            if index != columns.count - 1 {
                sql += "\(col.colName) = '\(col.colValue!)' and "
            }
            else{
                sql += "\(col.colName) = '\(col.colValue!)'"
            }
        }
        return SQliteRepository.db.execute(sql: sql)
    }
    
    // 删除数据
    class func deleteAll(tableName: String) -> CInt {
        let sql = "delete from \(tableName) "
        return SQliteRepository.db.execute(sql: sql)
    }
    
    // 查询表数据
    class func getData(tableName: String) -> [[String: Any]] {
        let sql = "select * from \(tableName)"
        return SQliteRepository.db.query(sql: sql)
    }
    
    // 用SQL自定义查询表数据
    class func sqlExcute(sql: String) -> [[String: Any]] {
        return SQliteRepository.db.query(sql: sql)
    }
}

public struct ColumnType {
    var colName: String
    var colType: String?
    var colValue: Any?
    
    init(colName: String, colType: String?, colValue: Any?) {
        self.colName = colName
        self.colType = colType
        self.colValue = colValue
    }
}
