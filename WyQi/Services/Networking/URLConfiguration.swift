//
//  URLConfiguration.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

extension Http {
    enum URLConfiguration {
        case searchRequest(String)
        case imageRequest(URL)
        case siteURL(String)
        
        func getRequest() -> Http.Request? {
            switch self {
            case let .imageRequest(url):
                return imageRequest(for: url)
            case let .searchRequest(query):
                return search(query)
            case .siteURL(_):
                return nil
            }
        }
        
        func formURL() -> URL? {
            switch self {
            case .imageRequest(_), .searchRequest(_):
                return nil
            case let .siteURL(title):
                let searchTitle = title.replacingOccurrences(of: " ", with: "_")
                return siteURL(for: searchTitle)
            }
        }
        
        private enum ParamInfo {
            case action
            case format
            case formatversion
            case prop
            case generator
            case redirects
            case piprop
            case pithumbsize
            case pilimit
            case wbptterms
            case gpssearch(String)
            case gpslimit
            
            func get() -> (key:String,value:String) {
                switch self {
                case .action:
                    return ("action","query")
                case .format:
                    return ("format","json")
                case .formatversion:
                    return ("formatversion","2")
                case .prop:
                    return ("prop","pageimages|pageterms")
                case .generator:
                    return ("generator","prefixsearch")
                case .redirects:
                    return ("redirects","1")
                case .piprop:
                    return ("piprop","thumbnail")
                case .pithumbsize:
                    return ("pithumbsize","150")
                case .pilimit:
                    return ("pilimit","30")
                case .wbptterms:
                    return ("wbptterms","description")
                case let .gpssearch(searchQuery):
                    return ("gpssearch","\(searchQuery)")
                case .gpslimit:
                    return ("gpslimit","30")
                }
            }
        }
        
        fileprivate func imageRequest(for url: URL) -> Http.Request? {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Http.Constants.httpGet.get()
            let request = Http.Request(request: urlRequest)
            return request
        }
        
        fileprivate func siteURL(for title: String) -> URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = URLPropertyConstants.urlScheme
            var hostComponents = [String]()
            if let locale = URLPropertyConstants.currentLocale {
                hostComponents.append(locale)
            }else{
                hostComponents.append(URLPropertyConstants.defaultLocale)
            }
            hostComponents.append(URLPropertyConstants.defaultSiteDomain)
            urlComponents.host = hostComponents.joined(separator: ".")
            urlComponents.path = URLPropertyConstants.internalLinkPathPrefix
            
            guard let url = urlComponents.url?.appendingPathComponent(title) else {
                print("Failed to form Search request URL")
                return nil
            }
            return url
        }

        fileprivate func search(_ query: String) -> Http.Request?{
            var urlComponents = URLComponents()
            urlComponents.scheme = URLPropertyConstants.urlScheme
            var hostComponents = [String]()
            if let locale = URLPropertyConstants.currentLocale {
                hostComponents.append(locale)
            }else{
                hostComponents.append(URLPropertyConstants.defaultLocale)
            }
            hostComponents.append(URLPropertyConstants.defaultSiteDomain)
            urlComponents.host = hostComponents.joined(separator: ".")
            urlComponents.path = URLPropertyConstants.apiPath
            
            var items = [URLQueryItem]()
            items.append(URLQueryItem(name: ParamInfo.action.get().key, value: ParamInfo.action.get().value))
            items.append(URLQueryItem(name: ParamInfo.format.get().key, value: ParamInfo.format.get().value))
            items.append(URLQueryItem(name: ParamInfo.formatversion.get().key, value: ParamInfo.formatversion.get().value))
            items.append(URLQueryItem(name: ParamInfo.prop.get().key, value: ParamInfo.prop.get().value))
            items.append(URLQueryItem(name: ParamInfo.generator.get().key, value: ParamInfo.generator.get().value))
            items.append(URLQueryItem(name: ParamInfo.redirects.get().key, value: ParamInfo.redirects.get().value))
            items.append(URLQueryItem(name: ParamInfo.piprop.get().key, value: ParamInfo.piprop.get().value))
            items.append(URLQueryItem(name: ParamInfo.pithumbsize.get().key, value: ParamInfo.pithumbsize.get().value))
            items.append(URLQueryItem(name: ParamInfo.pilimit.get().key, value: ParamInfo.pilimit.get().value))
            items.append(URLQueryItem(name: ParamInfo.wbptterms.get().key, value: ParamInfo.wbptterms.get().value))
            items.append(URLQueryItem(name: ParamInfo.gpssearch(query).get().key, value: ParamInfo.gpssearch(query).get().value))
            items.append(URLQueryItem(name: ParamInfo.gpslimit.get().key, value: ParamInfo.gpslimit.get().value))
            
            items = items.filter{!$0.name.isEmpty}
            if !items.isEmpty {
                urlComponents.queryItems = items
            }
            
            guard let url = urlComponents.url else {
                print("Failed to form Search request URL")
                return nil
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = Http.Constants.httpGet.get()
            let request = Http.Request(request: urlRequest)
            return request
        }
    }
}

extension Http{
    enum Constants {
        case httpGet
        case httpPost
        
        func get() -> String {
            switch self {
            case .httpGet:
                return "GET"
            case .httpPost:
                return "POST"

            }
        }
    }
    
    /*Redirection: 3xx status codes*/
    enum RedirectHttpCode {
        case multipleChoice
        case movedPermanently
        case movedTemporarily
        case seeOther
        case notModified
        case useProxy
        case temporaryRedirect
        case permanentRedirect
        
        func code() -> Int {
            switch self {
            case .multipleChoice:
                return 300
            case .movedPermanently:
                return 301
            case .movedTemporarily:
                return 302
            case .seeOther:
                return 303
            case .notModified:
                return 304
            case .useProxy:
                return 305
            case .temporaryRedirect:
                return 307
            case .permanentRedirect:
                return 308
            }
        }
    }
    
    struct URLPropertyConstants {
        static let httpTimeout: TimeInterval = 30.0
        static let urlScheme = "https"
        static let defaultLocale = "en"
        static let defaultSiteDomain = "wikipedia.org"
        static let internalLinkPathPrefix = "/wiki/"
        static let apiPath = "/w/api.php"
        
        static var currentLocale: String? {
            return Locale.current.languageCode
        }
    }
}
