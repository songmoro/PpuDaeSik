//
//  WeekTests.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 12/17/24.
//

import SwiftUI
import XCTest
@testable import PpuDaeSik

final class WeekTestsTests: XCTestCase {
    func test_이번_주_계산() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = Calendar().date(from: dateComponent)!
        
        let excepted: [WeekComponent] = [
            .init(dayComponent: .일, dayValue: 15),
            .init(dayComponent: .월, dayValue: 16),
            .init(dayComponent: .화, dayValue: 17),
            .init(dayComponent: .수, dayValue: 18),
            .init(dayComponent: .목, dayValue: 19),
            .init(dayComponent: .금, dayValue: 20),
            .init(dayComponent: .토, dayValue: 21),
        ]
        
        // Act
        let currentWeek = WeekComponent.calculateCurrentWeek(using: currentDate)
        
        // Assert
        XCTAssertEqual(currentWeek, excepted, "이번 주를 계산하는 함수가 정상 동작하지 않음.")
    }
    
    func test_이번_주_요일_검사() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = Calendar().date(from: dateComponent)!
        
        let excepted: [DayComponent] = [.일, .월, .화, .수, .목, .금, .토]
        
        // Act
        let currentWeek = WeekComponent.calculateCurrentWeek(using: currentDate)
            .map {
                $0.dayComponent
            }
        
        // Assert
        XCTAssertEqual(currentWeek, excepted, "이번 주의 요일 계산하는 함수가 정상 동작하지 않음.")
    }
    
    func test_이번_주_일_검사() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = Calendar().date(from: dateComponent)!
        
        let excepted: [Int] = [15, 16, 17, 18, 19, 20, 21]
        
        // Act
        let currentWeekday = WeekComponent.calculateCurrentWeek(using: currentDate)
            .map {
                $0.dayValue
            }
        
        // Assert
        XCTAssertEqual(currentWeekday, excepted, "이번 주의 일을 계산하는 함수가 정상 동작하지 않음.")
    }
    
    func test_올바르지_않은_이번_주_계산() {
        // Arrange
        let dateComponent = DateComponents(year: 2024, month: 12, day: 17)
        let currentDate = Calendar().date(from: dateComponent)!
        
        let excepted: [Int] = [10, 11, 12, 13, 14, 15, 16]
        
        // Act
        let currentWeekday = WeekComponent.calculateCurrentWeek(using: currentDate).map { $0.dayValue }
        
        // Assert
        XCTAssertNotEqual(currentWeekday, excepted, "올바르지 않은 값이 정상으로 표현됨.")
    }
}
