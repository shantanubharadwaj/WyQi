//
//  SavedPagesDBHandler.swift
//  WyQi
//
//  Created by Shantanu Dutta on 8/27/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation
import RealmSwift

struct SavedPagesDBHandler {
    static func persist(_ object: Object) {
        print("path : \(FileHelper.dbDirectory)")
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            realm.addOrUpdate(item: object)
        } catch let error {
            print("Fail to insert saved pages data in DB : [\(error)]")
        }
    }
    
    static func clearSavedData() {
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            realm.delete(ofType: SavedPagesDB.self)
        } catch let error {
            print("Fail to delete saved pages data in DB : [\(error)]")
        }
    }
    
    static func clearHistoryData() {
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            realm.delete(ofType: HistoryPagesDB.self)
        } catch let error {
            print("Fail to delete history pages data in DB : [\(error)]")
        }
    }
    
    static func clearHistoryQueryData() {
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            realm.delete(ofType: HistorySearchDB.self)
        } catch let error {
            print("Fail to delete history pages data in DB : [\(error)]")
        }
    }
    
    static func extractSavedData() ->  [PageInfo]? {
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            if let results = realm.getAll(ofType: SavedPagesDB.self)?.toArray(ofType: SavedPagesDB.self), results.isEmpty == false {
                let infoObject = results.map { (dbObject) -> PageInfo in
                    let obj = PageInfo(title: dbObject.title, body: dbObject.body, imageName: dbObject.imageName, imageSource: nil)
                    return obj
                }
                return infoObject
            }else{
                return nil
            }
        } catch let error {
            print("Fail to find data in DB : [\(error)]")
            return nil
        }
    }
    
    static func extractHistoryData() ->  [PageInfo]? {
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            if let results = realm.getAll(ofType: HistoryPagesDB.self)?.toArray(ofType: HistoryPagesDB.self), results.isEmpty == false {
                let infoObject = results.map { (dbObject) -> PageInfo in
                    let obj = PageInfo(title: dbObject.title, body: dbObject.body, imageName: dbObject.imageName, imageSource: nil)
                    return obj
                }
                return infoObject
            }else{
                return nil
            }
        } catch let error {
            print("Fail to find data in DB : [\(error)]")
            return nil
        }
    }
    
    static func extractHistoryQueryData() ->  [HistoryQueryList]? {
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            if let results = realm.getAll(ofType: HistorySearchDB.self)?.sorted(byKeyPath: "searchDate", ascending: false).toArray(ofType: HistorySearchDB.self), results.isEmpty == false {
                let infoObject = results.map { (dbObject) -> HistoryQueryList in
                    let obj = HistoryQueryList(queryString: dbObject.searchText, date: dbObject.searchDate)
                    return obj
                }
                return infoObject
            }else{
                return nil
            }
        } catch let error {
            print("Fail to find data in DB : [\(error)]")
            return nil
        }
    }
}
