//
//  HistoryViewModel.swift
//  WyQi
//
//  Created by Shantanu Dutta on 27/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

class HistoryViewModel {
    var historyObjects: Dynamic<Array<PageInfo>> = Dynamic([PageInfo]())
    
    let reachability = Reachability()
    
    func numberOfSections() -> Int {
        if historyObjects.value.count > 0 {
            return 1
        }else{
            return 0
        }
    }
    
    var isReachable: Bool {
        guard let reachability = reachability else {
            return true
        }
        let status = reachability.connection
        return (status == .wifi || status == .cellular) ? true : false
    }
    
    func retriveHistoryData() {
        historyObjects.value.removeAll()
        if let objects = SavedPagesDBHandler.extractHistoryData() {
            historyObjects.value = objects
        }
    }
    
    func numberOfRows() -> Int {
        return historyObjects.value.count
    }
    
    func savedInfo(for index: Int) -> PageInfo {
        return historyObjects.value[index]
    }
    
    func clearData() {
        historyObjects.value.removeAll()
        SavedPagesDBHandler.clearHistoryData()
    }
    
    func viewModelForCell(at index: Int) -> HistoryViewCellModel {
        return HistoryViewCellModel(info: savedInfo(for: index))
    }
}
