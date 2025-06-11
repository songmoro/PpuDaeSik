//
//  WeekComponentTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//


import XCTest
import Foundation
@testable import Entities

final class WeekComponentTests: XCTestCase {
    let calendar = Calendar(identifier: .gregorian)

    func test_이번_주_계산() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = calendar.date(from: dateComponent)!

        let expected: [WeekComponent] = (0..<7).compactMap { offset in
            guard let date = calendar.date(
                byAdding: .day,
                value: offset,
                to: calendar.date(
                    from: DateComponents(
                        weekOfYear: 51,
                        yearForWeekOfYear: 2024
                    )
                )!
            ) else { return nil }
            let weekday = calendar.component(.weekday, from: date)
            let dayComponent = DayComponent.from(weekday: weekday)
            return WeekComponent(dayComponent: dayComponent, date: date)
        }

        // Act
        let currentWeek = WeekComponent.calculateCurrentWeek(using: calendar, from: currentDate)

        // Assert
        XCTAssertEqual(currentWeek, expected, "이번 주를 계산하는 함수가 정상 동작하지 않음.")
    }

    func test_이번_주_요일_검사() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = calendar.date(from: dateComponent)!

        let expected: [DayComponent] = [.일, .월, .화, .수, .목, .금, .토]

        // Act
        let currentWeek = WeekComponent.calculateCurrentWeek(using: calendar, from: currentDate)
            .map { $0.dayComponent }

        // Assert
        XCTAssertEqual(currentWeek, expected, "이번 주의 요일 계산하는 함수가 정상 동작하지 않음.")
    }

    func test_이번_주_일_검사() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = calendar.date(from: dateComponent)!

        let expected: [Int] = [15, 16, 17, 18, 19, 20, 21]

        // Act
        let currentWeekday = WeekComponent.calculateCurrentWeek(using: calendar, from: currentDate)
            .map { $0.dayValue }

        // Assert
        XCTAssertEqual(currentWeekday, expected, "이번 주의 일을 계산하는 함수가 정상 동작하지 않음.")
    }

    func test_올바르지_않은_이번_주_계산() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = calendar.date(from: dateComponent)!

        let notExpected: [Int] = [10, 11, 12, 13, 14, 15, 16]

        // Act
        let currentWeekday = WeekComponent.calculateCurrentWeek(using: calendar, from: currentDate)
            .map { $0.dayValue }

        // Assert
        XCTAssertNotEqual(currentWeekday, notExpected, "올바르지 않은 값이 정상으로 표현됨.")
    }
    
    func test_todayIsCorrectlyCalculated() {
        let today = WeekComponent.getToday()
        XCTAssertEqual(today.dayComponent, DayComponent.from(weekday: Calendar.current.component(.weekday, from: Date())))
    }

    func test_currentWeekHasSevenDays() {
        let week = WeekComponent.calculateCurrentWeek()
        XCTAssertEqual(week.count, 7)
    }

    func test_weekComponentComparison() {
        let week = WeekComponent.calculateCurrentWeek()
        for i in 0..<6 {
            XCTAssertLessThan(week[i], week[i+1])
        }
    }
}
