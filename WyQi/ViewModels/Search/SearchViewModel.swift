//
//  SearchViewModel.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

struct HistoryQueryList {
    let queryString: String
    let date: Date
}

class SearchViewModel {
    var pages: Dynamic<Array<WPage>> = Dynamic([WPage]())
    
    var imagesService: ImageRequest?
    var searchService: SearchWikiService?
    fileprivate(set) var isSearchInProgress: Dynamic<Bool> = Dynamic(false)
    
    func numberOfSections() -> Int {
        if pages.value.count > 0 {
            return 1
        }else{
            return 0
        }
    }
    
    func numberOfRows() -> Int {
        return pages.value.count
    }
    
    func pageInfo(for index: Int) -> PageInfo {
        return pages.value[index].pageInfo()
    }
    
    func clearData() {
        pages.value.removeAll()
    }
    
    func saveHistoryData(for index: Int) {
        let info = pageInfo(for: index)
        let body = info.body
        let title = info.title
        if let thumbNailURL = info.imageSource {
            queryThumbnail(with: thumbNailURL) { (data) in
                if let imageData = data {
                    let imageName = "\(UUID().uuidString)".appending(".jpg")
                    let writePath = FileHelper.imageDirectory.appendingPathComponent(imageName)
                    _ = try? imageData.write(to: writePath, options: Data.WritingOptions.atomic)
                    let object = HistoryPagesDB(title, body: body, imageName: imageName)
                    SavedPagesDBHandler.persist(object)
                }else{
                    let object = HistoryPagesDB(title, body: body)
                    SavedPagesDBHandler.persist(object)
                }
            }
        }else{
            let object = HistoryPagesDB(title, body: body)
            SavedPagesDBHandler.persist(object)
        }
    }
    
    fileprivate func queryThumbnail(with url: URL, completion: @escaping (Data?) -> ()) {
        imagesService = ImageRequest(url: url)
        imagesService?.fetch{ (data) in
            completion(data)
        }
    }
    
    func query(for text: String) {
        clearData()
        searchService = SearchWikiService(text)
        isSearchInProgress.value = true
        searchService?.fetchData { [weak self] (queryPages) in
            self?.isSearchInProgress.value = false
            if let pages = queryPages?.pages, !pages.isEmpty {
                self?.pages.value = pages.sorted { $0.index < $1.index }
            }
        }
    }
    
    func viewModelForCell(at index: Int) -> SearchViewCellModel {
        return SearchViewCellModel(info: pageInfo(for: index))
    }
}
