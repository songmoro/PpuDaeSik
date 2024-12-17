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
        let excepted: [WeekComponent] = [
            WeekComponent(dayComponent: <#T##DayComponent#>, dayValue: <#T##Int#>),
            WeekComponent(dayComponent: <#T##DayComponent#>, dayValue: <#T##Int#>),
            WeekComponent(dayComponent: <#T##DayComponent#>, dayValue: <#T##Int#>),
            WeekComponent(dayComponent: <#T##DayComponent#>, dayValue: <#T##Int#>),
            WeekComponent(dayComponent: <#T##DayComponent#>, dayValue: <#T##Int#>)
        ]
        
        // Act
        let currentWeek = WeekComponent.calculateCurrentWeek()
        
        // Assert
    }
}
