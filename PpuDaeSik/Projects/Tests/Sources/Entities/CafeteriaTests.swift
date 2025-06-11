//
//  CafeteriaTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import Entities

final class CafeteriaTests: XCTestCase {
    func test_initWithValidCode() {
        XCTAssertEqual(Cafeteria("PG001"), .금정회관교직원식당)
        XCTAssertEqual(Cafeteria("PG002"), .금정회관학생식당)
        XCTAssertEqual(Cafeteria("PS001"), .샛벌회관식당)
        XCTAssertEqual(Cafeteria("PH002"), .학생회관학생식당)
        XCTAssertEqual(Cafeteria("M001"), .학생회관밀양학생식당)
        XCTAssertEqual(Cafeteria("M002"), .학생회관밀양교직원식당)
        XCTAssertEqual(Cafeteria("Y001"), .편의동2층양산식당)
        XCTAssertEqual(Cafeteria("2"), .진리관)
        XCTAssertEqual(Cafeteria("11"), .웅비관)
        XCTAssertEqual(Cafeteria("13"), .자유관)
        XCTAssertEqual(Cafeteria("3"), .비마관)
        XCTAssertEqual(Cafeteria("12"), .행림관)
    }

    func test_initWithInvalidCode() {
        let cafeteria = Cafeteria("INVALID")
        XCTAssertNil(cafeteria)
    }

    func test_campusMapping() {
        XCTAssertEqual(Cafeteria.진리관.campus, .부산)
        XCTAssertEqual(Cafeteria.비마관.campus, .밀양)
        XCTAssertEqual(Cafeteria.행림관.campus, .양산)
    }
}
