//
//  FileHelper.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

struct FileHelper {
    fileprivate static let appRootDirectory = "Root"
    fileprivate static let realmDBDirectory = "RealmFiles"
    fileprivate static let savedThumbnailImageDirectory = "ImageDirectory"
    
    static var documentsDirectory: URL {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return URL(fileURLWithPath: paths[0])
    }
    
    static var dbDirectory: URL {
        return FileHelper.documentsDirectory.appendingPathComponent(realmDBDirectory)
    }
    
    static var imageDirectory: URL {
        let imgDirURL = FileHelper.documentsDirectory.appendingPathComponent(savedThumbnailImageDirectory)
        createDirectoryIfAbsent(for: imgDirURL)
        return imgDirURL
    }
    
    static func createDirectoryIfAbsent(for filePath: URL){
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(at: filePath, withIntermediateDirectories: true, attributes: nil)
            }catch let error {
                print("Failed to create directory at path:\(filePath.absoluteString), Error : \(error)")
            }
        }
    }
}
