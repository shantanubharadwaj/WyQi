//
//  CodableExtensions.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

enum JsonEncodeDecodeError: Error {
    case dataConversionFail
    case stringConverionFail
    var localizedDescription: String{
        switch self {
        case .dataConversionFail:
            return "<JsonEncodeDecodeError> : Failure in converting string to utf8 encoded data"
        case .stringConverionFail:
            return "<JsonEncodeDecodeError> : Failure in converting data to utf8 encoded string"
        }
    }
}

extension String{
    func decode<O: Decodable>() throws -> O {
        guard let data = self.data(using: .utf8) else {
            throw JsonEncodeDecodeError.dataConversionFail
        }
        let decoder = JSONDecoder()
        return try decoder.decode(O.self, from: data)
    }
}

extension Data {
    func decode<O: Decodable>() throws -> O {
        let decoder = JSONDecoder()
        return try decoder.decode(O.self, from: self)
    }
}
