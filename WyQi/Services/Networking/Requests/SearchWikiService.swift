//
//  SearchWikiService.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

struct SearchWikiService {
    fileprivate let httpWorker = Http.create("SearchService")
    private let operationQueue = OperationQueue()
    private let searchQuery: String
    
    init(_ query: String) {
        searchQuery = query
    }
    
    /// use this api to call the nextURL (if available) which was passed in the Link header during initial call.
    func fetchData(_ response: ((QueryPages?) -> ())?) {
        guard let request = Http.URLConfiguration.searchRequest(searchQuery).getRequest(), let _ = request.urlRequest.url else {
            response?(nil)
            return
        }
        
        httpWorker.cancelAll()
        
        let networkOperation = RequestData(withURLRequest: request, andNetworkingProvider: httpWorker)
        networkOperation.qualityOfService = .userInitiated
        networkOperation.completionBlock = {
            if networkOperation.error != nil {
                print("<SearchWikiService> fetch data : Error in HTTP : [StatusCode : \(String(describing: networkOperation.response?.urlResponse.statusCode))] : <error  [\(String(describing: networkOperation.error))]>")
                response?(nil)
                return
            }
            guard let httpResponse = networkOperation.response, let validdata = httpResponse.data else{
                response?(nil)
                return
            }
            
            do{
                let querydata: QueryData = try validdata.decode()
                if querydata.query.pages.count > 0 {
                    response?(querydata.query)
                }else{
                    print("<SearchRepoService> fetch data : No data found")
                    response?(nil)
                }
            }catch let error {
                print("<SearchRepoService> fetch data : Error while parsing : [\(error.localizedDescription)]")
                response?(nil)
            }
        }
        operationQueue.addOperations([networkOperation], waitUntilFinished: false)
    }
}
