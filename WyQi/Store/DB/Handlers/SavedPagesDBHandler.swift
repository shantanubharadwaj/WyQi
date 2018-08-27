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
    
    static func clearData() {
        do {
            let realm = try RLMDataStore.savedArticles(RLMDataStore.DBConfig.savedArticles.get()).get()
            realm.deleteAll()
        } catch let error {
            print("Fail to insert saved pages data in DB : [\(error)]")
        }
    }
    
    static func extractData() ->  [PageInfo]? {
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
            print("Fail to find inflight data in DB : [\(error)]")
            return nil
        }
    }
}
