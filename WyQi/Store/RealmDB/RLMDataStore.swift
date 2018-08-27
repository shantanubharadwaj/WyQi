//
//  RLMDataStore.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation
import RealmSwift

protocol StoreFileInfo {
    associatedtype T
    func get() -> T
}

enum RLMDataStore {
    case savedArticles(RLMDBConfig)
    
    func get() throws -> RLMStoreDB {
        switch self {
        case let .savedArticles(config):
            return try RLMDBHandler(config)
        }
    }
}

extension RLMDataStore {
    enum DBSchemaVersion: StoreFileInfo {
        case savedArticles
        
        func get() -> UInt64 {
            switch self {
            case .savedArticles:
                return 1
            }
        }
    }
    
    enum DBFile: StoreFileInfo {
        case savedArticles
        func get() -> URL {
            switch self {
            case .savedArticles:
                let dbFilePath =  FileHelper.dbDirectory.appendingPathComponent("SavedArticles")
                FileHelper.createDirectoryIfAbsent(for: dbFilePath)
                return dbFilePath.appendingPathComponent("SavedData.realm")
            }
        }
    }
    
    enum ObjectTypeList: StoreFileInfo {
        case savedArticles

        func get() -> [Object.Type] {
            switch self {
            case .savedArticles:
                return [SavedPagesDB.self, HistoryPagesDB.self, HistorySearchDB.self]
            }
        }
    }
    
    enum DBConfig: StoreFileInfo {
        case savedArticles
        
        func get() -> RLMDBConfig {
            switch self {
            case .savedArticles:
                return RLMDBConfig(fileLocation: RLMDataStore.DBFile.savedArticles.get(), schemaVersion: RLMDataStore.DBSchemaVersion.savedArticles, shouldDeleteRealmIfMigrationNeeded: true, objectList: ObjectTypeList.savedArticles.get())
            }
        }
    }
}
