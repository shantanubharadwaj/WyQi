//
//  WebViewModel.swift
//  WyQi
//
//  Created by Shantanu Dutta on 8/27/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

class WebViewModel {
    var pageInfo: PageInfo!
    var imagesService: ImageRequest?
    
    func siteURL() -> URL? {
        return Http.URLConfiguration.siteURL(pageInfo.title).formURL()
    }
    
    func saveLoadedData() {
        let body = pageInfo.body
        let title = pageInfo.title
        if let thumbNailURL = pageInfo.imageSource {
            queryThumbnail(with: thumbNailURL) { (data) in
                if let imageData = data {
                    let imageName = "\(UUID().uuidString)".appending(".jpg")
                    let writePath = FileHelper.imageDirectory.appendingPathComponent(imageName)
                    _ = try? imageData.write(to: writePath, options: Data.WritingOptions.atomic)
                    let object = SavedPagesDB(title, body: body, imageName: imageName)
                    SavedPagesDBHandler.persist(object)
                }else{
                    let object = SavedPagesDB(title, body: body)
                    SavedPagesDBHandler.persist(object)
                }
            }
        }else{
            let object = SavedPagesDB(title, body: body)
            SavedPagesDBHandler.persist(object)
        }
    }
    
    fileprivate func queryThumbnail(with url: URL, completion: @escaping (Data?) -> ()) {
        imagesService = ImageRequest(url: url)
        imagesService?.fetch{ (data) in
            completion(data)
        }
    }
}
