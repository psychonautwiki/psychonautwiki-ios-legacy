//
//  FuzzySearchText.swift
//  PsychonautWiki
//
//  Created by Waldemar Barbe on 27.03.17.
//  Copyright © 2017 Waldemar Barbe. All rights reserved.
//

import XCTest
@testable import PsychonautWiki

class FuzzySearchText: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFuzzySearch() {
        XCTAssertTrue("Hello World".containsFuzzy("Hello"))
        XCTAssertTrue("Hello World".containsFuzzy("World"))
        XCTAssertTrue("Hello World".containsFuzzy("HeWo"))
        XCTAssertTrue("Hello World".containsFuzzy("heowld"))
        XCTAssertTrue("Hello World".containsFuzzy("He  o"))
        XCTAssertFalse("Hello World".containsFuzzy("HaWo"))
        XCTAssertFalse("Hello World".containsFuzzy("Hallo"))
        XCTAssertFalse("Hello World".containsFuzzy("Helled"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
