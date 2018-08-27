//
//  SavedViewModel.swift
//  WyQi
//
//  Created by Shantanu Dutta on 8/27/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

class SavedViewModel {
    var savedObjects: Dynamic<Array<PageInfo>> = Dynamic([PageInfo]())
    
    func numberOfSections() -> Int {
        if savedObjects.value.count > 0 {
            return 1
        }else{
            return 0
        }
    }
    
    func retriveSavedData() {
        savedObjects.value.removeAll()
        if let objects = SavedPagesDBHandler.extractData() {
            savedObjects.value = objects
        }
    }
    
    func numberOfRows() -> Int {
        return savedObjects.value.count
    }
    
    func savedInfo(for index: Int) -> PageInfo {
        return savedObjects.value[index]
    }
    
    func clearData() {
        savedObjects.value.removeAll()
        SavedPagesDBHandler.clearData()
    }
    
    func viewModelForCell(at index: Int) -> SavedViewCellModel {
        return SavedViewCellModel(info: savedInfo(for: index))
    }
}
