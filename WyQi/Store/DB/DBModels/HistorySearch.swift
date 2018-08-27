//
//  HistorySearch.swift
//  WyQi
//
//  Created by Shantanu Dutta on 28/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class HistorySearchDB: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var searchText: String = ""
    dynamic var searchDate = Date()
    
    convenience init(_ query: String) {
        self.init()
        self.searchText = query
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
