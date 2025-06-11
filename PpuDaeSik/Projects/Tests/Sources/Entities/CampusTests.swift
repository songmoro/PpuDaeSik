//
//  CampusTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import Entities

final class CampusTests: XCTestCase {
    func test_initWithValidRawValue() {
        XCTAssertEqual(Campus("부산"), .부산)
        XCTAssertEqual(Campus("밀양"), .밀양)
        XCTAssertEqual(Campus("양산"), .양산)
    }

    func test_initWithInvalidRawValue() {
        XCTAssertNil(Campus("서울"))
    }
}
