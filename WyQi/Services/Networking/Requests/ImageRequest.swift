//
//  ImageRequest.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

class ImageRequest {
    fileprivate let httpWorker = Http.create("ImageService")
    private let operationQueue = OperationQueue()
    private let imageURL: URL
    init(url: URL) {
        imageURL = url
    }
    
    func fetch(_ response: ((Data?) -> ())?){
        guard let request = Http.URLConfiguration.imageRequest(imageURL).getRequest(), let _ = request.urlRequest.url else {
            response?(nil)
            return
        }
        
        let networkOperation = RequestData(withURLRequest: request, andNetworkingProvider: httpWorker)
        networkOperation.qualityOfService = .userInitiated
        
        networkOperation.completionBlock = {
            if networkOperation.error != nil {
                print("<ImageRequest> : Error in HTTP : [StatusCode : \(String(describing: networkOperation.response?.urlResponse.statusCode))] : <error  [\(String(describing: networkOperation.error))]>")
                response?(nil)
                return
            }
            guard let httpResponse = networkOperation.response, let responseData = httpResponse.data else{
                response?(nil)
                return
            }
            
            response?(responseData)
        }
        
        operationQueue.addOperations([networkOperation], waitUntilFinished: false)
    }
}

