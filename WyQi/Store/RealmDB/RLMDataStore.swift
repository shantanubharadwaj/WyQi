//
//  RLMDataStore.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

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
}
