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
    var shouldDeleteRealmIfMigrationNeeded: Bool = false
    var objectList: [Object.Type]?
    
    init(fileLocation: URL, schemaVersion: RLMDataStore.DBSchemaVersion, shouldDeleteRealmIfMigrationNeeded: Bool = false, objectList: [Object.Type]? = nil) {
        self.fileLocation = fileLocation
        self.schemaVersion = schemaVersion
        self.shouldDeleteRealmIfMigrationNeeded = shouldDeleteRealmIfMigrationNeeded
        self.objectList = objectList
    }
}

protocol RLMStoreDB {
    func insert(item: Object)
    func addOrUpdate(item: Object)
    func deleteAll()
    func delete(ofType type:Object.Type)
    func find(predicate:NSPredicate, type:Object.Type) -> Results<Object>?
    func getAll(ofType type:Object.Type) -> Results<Object>?
}

struct RLMDBHandler: RLMStoreDB {
    fileprivate var realmObject: Realm?
    fileprivate let config: RLMDBConfig
    
    init(_ config: RLMDBConfig) throws {
        self.config = config
        var configuration = Realm.Configuration(fileURL: config.fileLocation, schemaVersion: config.schemaVersion.get())
        if config.shouldDeleteRealmIfMigrationNeeded {
            configuration.deleteRealmIfMigrationNeeded = true
        }
        configuration.migrationBlock = {(migration, oldSchemaVersion) in
            print("DBHandler:: Called Migration, old schema: \(oldSchemaVersion)")
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
    
    func addOrUpdate(item: Object) {
        guard FileManager.default.fileExists(atPath: config.fileLocation.path) else {
            print("RLMDB not created. Storage object information absent")
            return
        }
        guard let realm = realmObject else { return }
        do {
            try realm.write {
                realm.add(item, update: true)
            }
        }
        catch let error  {
            print("DBHandler::update failed with error:\(error.localizedDescription)")
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
    
    func delete(ofType type:Object.Type){
        guard FileManager.default.fileExists(atPath: config.fileLocation.path) else {
            print("RLMDB not created. Storage object information absent")
            return
        }
        guard let realm = realmObject else { return }
        do {
            print("DBHandler::Delete item \(type)")
            let items = realm.objects(type)
            try realm.write {
                realm.delete(items)
            }
        }
        catch let error  {
            print("DBHandler::delete ofType failed with error:\(error.localizedDescription)")
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
