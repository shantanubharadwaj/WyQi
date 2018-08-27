//
//  SearchViewModel.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

class SearchViewModel {
    var pages: Dynamic<Array<WPage>> = Dynamic([WPage]())
    
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
    
    func pageInfo(for index: Int) -> WPage {
        return pages.value[index]
    }
    
    func clearData() {
        pages.value.removeAll()
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
    
    func siteURL(for index: Int) -> URL? {
        let title = pages.value[index].title
        return Http.URLConfiguration.siteURL(title).formURL()
    }
    
    func viewModelForCell(at index: Int) -> SearchViewCellModel {
        return SearchViewCellModel(info: pageInfo(for: index))
    }
}
