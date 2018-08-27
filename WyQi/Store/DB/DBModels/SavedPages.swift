//
//  SavedPages.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class SavedPagesDB: Object {
    dynamic var title: String = ""
    dynamic var body: String? = nil
    dynamic var imageName: String? = nil
    
    convenience init(_ title: String, body: String? = nil, imageName: String? = nil) {
        self.init()
        self.title = title
        self.body = body
        self.imageName = imageName
    }
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
