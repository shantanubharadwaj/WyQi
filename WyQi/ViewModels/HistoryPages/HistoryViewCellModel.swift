//
//  HistoryViewCellModel.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

class HistoryViewCellModel {
    let pageInfo: PageInfo
    let title: Dynamic<String>
    let body: Dynamic<String?>
    let thumbnail: Dynamic<String?>
    
    init(info : PageInfo) {
        pageInfo = info
        title = Dynamic(pageInfo.title)
        body = Dynamic(pageInfo.body)
        thumbnail = Dynamic(pageInfo.imageName)
    }
}
