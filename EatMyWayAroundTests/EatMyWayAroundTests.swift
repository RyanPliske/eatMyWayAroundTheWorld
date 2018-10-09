//
//  EatMyWayAroundTests.swift
//  EatMyWayAroundTests
//
//  Created by Courtney Yoo on 5/9/18.
//  Copyright © 2018 Courtney Yoo. All rights reserved.
//

import XCTest
@testable import EatMyWayAround

class EatMyWayAroundTests: XCTestCase {
    func testJSONConverter() {
        let fetcher = RestaurantDataFetcher()
        let testJSON = json("serverExample")
        let restaurants = fetcher.convert(json: testJSON)
        XCTAssertEqual(20, restaurants.count)
    }
    
}

extension XCTestCase {
    func json(_ fileName: String) -> JSON {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json"),
            let data = NSData(contentsOfFile: path),
            let unwrappedData = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON,
            let testData = unwrappedData else {
                XCTFail()
                return JSON()
        }
        return testData
    }
}
