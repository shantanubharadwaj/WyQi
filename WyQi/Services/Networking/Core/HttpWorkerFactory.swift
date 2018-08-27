//
//  HttpWorkerFactory.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http{
    // Create instance of httpWorker, while passing a string value to differentiate between different callers
    static func create(_ creator: String) -> HttpWorker {
        return NetworkConnector(creator)
    }
}
