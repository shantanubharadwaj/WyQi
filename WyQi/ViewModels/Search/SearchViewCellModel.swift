//
//  SearchViewCellModel.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

class SearchViewCellModel {
    
    let pageInfo: PageInfo
    let title: Dynamic<String>
    let body: Dynamic<String?>
    let thumbnail: Dynamic<Data?>
    
    var imagesService: ImageRequest?
    
    init(info : PageInfo) {
        pageInfo = info
        title = Dynamic(pageInfo.title)
        body = Dynamic(pageInfo.body)
        thumbnail = Dynamic(nil)
        if let url = pageInfo.imageSource {
            queryThumbnail(with: url)
        }
    }
    
    func queryThumbnail(with url: URL) {
        imagesService = ImageRequest(url: url)
        imagesService?.fetch{ [weak self] (data) in
            self?.thumbnail.value = data
        }
    }
}
