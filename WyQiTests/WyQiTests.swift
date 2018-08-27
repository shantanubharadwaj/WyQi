//
//  WyQiTests.swift
//  WyQiTests
//
//  Created by Shantanu Dutta on 26/08/18.
//  Copyright © 2018 Shantanu Dutta. All rights reserved.
//

import XCTest
@testable import WyQi

class WyQiTests: XCTestCase {
    
    let inputData1 = """
{"batchcomplete":true,"continue":{"gpsoffset":10,"continue":"gpsoffset||"},"query":{"pages":[{"pageid":47737,"ns":0,"title":"Las Vegas","index":1,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/DowntownLasVegas.jpg/300px-DowntownLasVegas.jpg","width":300,"height":194},"terms":{"description":["city in and county seat of Clark County, Nevada, United States"]}},{"pageid":125983,"ns":0,"title":"Las Vegas, New Mexico","index":8,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Downtown_Las_Vegas%2C_NM.JPG/300px-Downtown_Las_Vegas%2C_NM.JPG","width":300,"height":200},"terms":{"description":["town in New Mexico, USA"]}},{"pageid":247287,"ns":0,"title":"Las Vegas 51s","index":9,"terms":{"description":["American minor league baseball team"]}},{"pageid":322146,"ns":0,"title":"Las Vegas (TV series)","index":4,"terms":{"description":["television series"]}},{"pageid":447621,"ns":0,"title":"Las Vegas Strip","index":2,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Las_Vegas_%2822096744189%29.jpg/300px-Las_Vegas_%2822096744189%29.jpg","width":300,"height":188},"terms":{"description":["a 4 mile stretch of Las Vegas Boulevard with many resorts, shows, and casinos"]}},{"pageid":665172,"ns":0,"title":"Las Vegas Valley","index":3,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/e/ee/View_of_Las_Vegas%27_strip_from_the_helicopter.jpg/300px-View_of_Las_Vegas%27_strip_from_the_helicopter.jpg","width":300,"height":177},"terms":{"description":["metropolitan area in the southern part of the U.S. state of Nevada"]}},{"pageid":1578776,"ns":0,"title":"Las Vegas Metropolitan Police Department","index":5,"terms":{"description":["municipal police"]}},{"pageid":1809119,"ns":0,"title":"Las Vegas Wranglers","index":10,"terms":{"description":["ice hockey team"]}},{"pageid":52047141,"ns":0,"title":"Las Vegas Stadium","index":7,"terms":{"description":["domed stadium under construction in Las Vegas, Nevada"]}},{"pageid":55631868,"ns":0,"title":"Las Vegas Aces","index":6,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/en/thumb/f/fb/Las_Vegas_Aces_logo.svg/214px-Las_Vegas_Aces_logo.svg.png","width":214,"height":300},"terms":{"description":["women's professional basketball team in Las Vegas, Nevada"]}}]}}
"""
    
    let inputData2 = """
{"batchcomplete":true,"continue":{"gpsoffset":10,"continue":"gpsoffset||"},"query":{"redirects":[{"index":9,"from":"Nikola Tesla (Sanctuary)","to":"Characters of Sanctuary","tofragment":"Nikola Tesla"},{"index":8,"from":"Nikola Tesla vs. Thomas Edison","to":"Epic Rap Battles of History"},{"index":6,"from":"Nikola Tesla (airport)","to":"Belgrade Nikola Tesla Airport"}],"pages":[{"pageid":21473,"ns":0,"title":"Nikola Tesla","index":1,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/N.Tesla.JPG/230px-N.Tesla.JPG","width":230,"height":300},"terms":{"description":["Serbian American inventor"]}},{"pageid":1467219,"ns":0,"title":"Belgrade Nikola Tesla Airport","index":6,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/BAM-68-Kompleks_AB-JAT-MVB.jpg/300px-BAM-68-Kompleks_AB-JAT-MVB.jpg","width":300,"height":225},"terms":{"description":["main international airport of Serbia"]}},{"pageid":4039179,"ns":0,"title":"Nikola Tesla electric car hoax","index":4},{"pageid":4966622,"ns":0,"title":"Nikola Tesla Museum","index":3,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Museum_of_Nikola_Tesla%2C_Belgrade%2C_Serbia-cropped.JPG/300px-Museum_of_Nikola_Tesla%2C_Belgrade%2C_Serbia-cropped.JPG","width":300,"height":276},"terms":{"description":["museum in Serbia"]}},{"pageid":7409536,"ns":0,"title":"Nikola Tesla in popular culture","index":2},{"pageid":19599678,"ns":0,"title":"Characters of Sanctuary","index":9,"terms":{"description":["Wikimedia list article"]}},{"pageid":33204167,"ns":0,"title":"Nikola Tesla (Niška Banja)","index":10,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Broj_6.JPG/300px-Broj_6.JPG","width":300,"height":225},"terms":{"description":["village in Niška Banja"]}},{"pageid":33592458,"ns":0,"title":"Epic Rap Battles of History","index":8,"terms":{"description":["YouTube video series"]}},{"pageid":38048901,"ns":0,"title":"Nikola Tesla Satellite Award","index":5},{"pageid":38479710,"ns":0,"title":"Nikola Tesla (disambiguation)","index":7,"terms":{"description":["Wikimedia disambiguation page"]}}]}}
"""
    
    struct Info: CustomStringConvertible {
        let title: String
        let image: URL
        
        var description: String{
            return "[Title : \(title) || Image : \(image.absoluteString)]"
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInput1() {
        do {
            let response: Query = try inputData1.decode()
            let pagesCount = response.query.pages.count
            print("Count of pages : \(pagesCount)")
            let titleArr = response.query.pages.map { $0.title }
            print("Title Array : \(titleArr)")
            let infoArr = response.query.pages.compactMap { (page) -> Info? in
                if let imgUrl = page.thumbnail?.source {
                    return Info(title: page.title, image: imgUrl)
                }else{
                    return nil
                }
            }
            
            print("InfoArr : Count : \(infoArr.count) \n\n Arr >> : \(infoArr)")
            
            XCTAssertEqual(pagesCount, titleArr.count, "Titles and retrieved pages do not match")
        } catch let error {
            XCTFail("Parsing failed with error : \(error)")
        }
    }
    
    func testInput2() {
        do {
            let response: Query = try inputData2.decode()
            let pagesCount = response.query.pages.count
            print("Count of pages : \(pagesCount)")
            let titleArr = response.query.pages.map { $0.title }
            print("Title Array : \(titleArr)")
            let infoArr = response.query.pages.compactMap { (page) -> Info? in
                if let imgUrl = page.thumbnail?.source {
                    return Info(title: page.title, image: imgUrl)
                }else{
                    return nil
                }
            }
            
            print("InfoArr : Count : \(infoArr.count) \n\n Arr >> : \(infoArr)")
            
            XCTAssertEqual(pagesCount, titleArr.count, "Titles and retrieved pages do not match")
        } catch let error {
            XCTFail("Parsing failed with error : \(error)")
        }
    }
}
