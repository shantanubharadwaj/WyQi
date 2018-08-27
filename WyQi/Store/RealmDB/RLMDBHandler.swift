//
//  RLMDBHandler.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation
import RealmSwift

struct RLMDBConfig {
    let fileLocation: URL
    let schemaVersion: RLMDataStore.DBSchemaVersion
    var objectList: [Object.Type]?
}

protocol RLMStoreDB {
    func insert(item: Object)
    func deleteAll()
    func find(predicate:NSPredicate, type:Object.Type) -> Results<Object>?
    func getAll(ofType type:Object.Type) -> Results<Object>?
}

struct RLMDBHandler: RLMStoreDB {
    fileprivate var realmObject: Realm?
    fileprivate let config: RLMDBConfig
    
    init(_ config: RLMDBConfig) throws {
        self.config = config
        var configuration = Realm.Configuration(fileURL: config.fileLocation, schemaVersion: config.schemaVersion.get())
        configuration.migrationBlock = {(migration, oldSchemaVersion) in
            if oldSchemaVersion < config.schemaVersion.get() {
                //
            }
        }
        
        if let list = config.objectList {
            configuration.objectTypes = list
        }
        realmObject = try Realm(configuration: configuration)
    }
    
    func insert(item: Object){
        guard FileManager.default.fileExists(atPath: config.fileLocation.path) else {
            print("RLMDB not created. Storage object information absent")
            return
        }
        guard let realm = realmObject else { return }
        do {
            print("DBHandler::insert item \(item)")
            try realm.write {
                realm.add(item)
            }
        }
        catch let error  {
            print("DBHandler::insert failed with error:\(error.localizedDescription)")
        }
    }
    
    func deleteAll() {
        guard FileManager.default.fileExists(atPath: config.fileLocation.path) else {
            print("RLMDB not created. Storage object information absent")
            return
        }
        guard let realm = realmObject else { return }
        do {
            try realm.write {
                realm.deleteAll()
            }
        }
        catch let error  {
            print("DBHandler::deleteAll failed with error:\(error.localizedDescription)")
        }
    }
    
    func find(predicate:NSPredicate, type:Object.Type)-> Results<Object>? {
        guard FileManager.default.fileExists(atPath: config.fileLocation.path) else {
            print("RLMDB not created. Storage object information absent")
            return nil
        }
        guard let realm = realmObject else { return nil }
        let results = realm.objects(type).filter(predicate)
        return results
    }
    
    func getAll(ofType type:Object.Type) -> Results<Object>? {
        guard FileManager.default.fileExists(atPath: config.fileLocation.path) else {
            print("RLMDB not created. Storage object information absent")
            return nil
        }
        guard let realm = realmObject else { return nil }
        let results = realm.objects(type)
        return results
    }
}
