//
//  WPage.swift
//  WyQi
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import Foundation

struct QueryData: Decodable{
    let query: QueryPages
}

struct QueryPages: Decodable {
    let pages: [WPage]
}

struct WPage: Decodable {
    let index: Int
    let title: String
    var terms: PageDescription?
    var thumbnail: Image?
    
    func siteURL() -> URL? {
        return Http.URLConfiguration.siteURL(title).formURL()
    }
    
    func pageInfo() -> PageInfo {
        return PageInfo(title: title, body: terms?.description.first, imageName: nil, imageSource: thumbnail?.source)
    }
}

struct PageInfo {
    let title: String
    var body: String?
    var imageName: String?
    var imageSource: URL?
}

struct Image: Decodable {
    var source: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let urlString = try container.decodeIfPresent(String.self, forKey: .source), let url = URL(string: urlString) {
            source = url
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case source
    }
}

struct PageDescription: Decodable {
    let description: [String]
}
