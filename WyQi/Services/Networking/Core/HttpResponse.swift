//
//  HttpResponse.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http{
    struct Response {
        fileprivate var response: HTTPURLResponse
        var urlResponse: HTTPURLResponse { get { return self.response } }
        
        fileprivate var responseData: Data?
        var data:Data? { get {return responseData } }
        var dataAsString: String? { get { return getDataAsString(String.Encoding.utf8) } }
        
        fileprivate var _finalURL: URL?
        var finalURL: URL? { get { return self._finalURL} }
        
        init(httpResponse: HTTPURLResponse, data: Data?, finalURL: URL? = nil) {
            response = httpResponse
            responseData = data
            _finalURL = finalURL
        }
        
        //MARK:- Public Functions
        func getDataAsString(_ encoding: String.Encoding) -> String? {
            guard let validData = self.responseData else {
                return nil
            }
            return NSString(data: validData, encoding: encoding.rawValue) as String?
        }
    }
}
