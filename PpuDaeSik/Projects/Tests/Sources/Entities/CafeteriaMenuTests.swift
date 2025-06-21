//
//  CafeteriaMenuTests.swift
//  Tests
//
//  Created by 송재훈 on 6/21/25.
//

import XCTest
@testable import Entities

final class CafeteriaMenuTests: XCTestCase {
    func test_isValid_returnsTrue_whenSameCampusAndSameWeek() {
        // given
        let today = Date()
        let dateString = Self.formatDate(today)
        let menu = CafeteriaMenu(
            cafeteria: .학생회관학생식당,
            date: dateString,
            category: .중식,
            title: nil,
            content: "된장찌개"
        )
        
        // when
        let result = menu.isValid(.부산, today)

        // then
        XCTAssertTrue(result)
    }

    func test_isValid_returnsFalse_whenDifferentCampus() {
        // given
        let today = Date()
        let dateString = Self.formatDate(today)
        let menu = CafeteriaMenu(
            cafeteria: .학생회관밀양학생식당, // campus: .밀양
            date: dateString,
            category: .중식,
            title: nil,
            content: "김치찌개"
        )
        
        // when
        let result = menu.isValid(.부산, today)

        // then
        XCTAssertFalse(result)
    }

    func test_isValid_returnsFalse_whenDifferentWeek() {
        // given
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let dateString = Self.formatDate(lastWeek)
        let menu = CafeteriaMenu(
            cafeteria: .학생회관학생식당,
            date: dateString,
            category: .중식,
            title: nil,
            content: "된장찌개"
        )
        
        // when
        let result = menu.isValid(.부산, Date())

        // then
        XCTAssertFalse(result)
    }

    func test_isValid_returnsFalse_whenInvalidDateFormat() {
        // given
        let menu = CafeteriaMenu(
            cafeteria: .학생회관학생식당,
            date: "06/18/2025", // 잘못된 형식
            category: .중식,
            title: nil,
            content: "불고기"
        )
        
        // when
        let result = menu.isValid(.부산)

        // then
        XCTAssertFalse(result)
    }
    
    // MARK: - Helper
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}
