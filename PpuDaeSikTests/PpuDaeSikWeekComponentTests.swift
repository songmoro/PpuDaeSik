//
//  PpuDaeSikWeekComponentTests.swift
//  PpuDaeSikTests
//
//  Created by 송재훈 on 8/26/24.
//

import XCTest
@testable import PpuDaeSik

/// WeekComponent에 대한 테스트
final class PpuDaeSikWeekComponentTests: XCTestCase {
    let date = Date.now
    let calendar = Calendar()
    let dateFormatter = DateFormatter()
    
    override func setUp() {
        super.setUp()
    }
    
    /// 옵셔널 WeekComponent인 today가 nil을 반환하는지 검사
    func test_nil_검사() {
        XCTAssertNotNil(WeekComponent.today, "WeekComponent.today가 nil을 반환함")
    }
    
    /// 오늘 날짜를 대입한 WeekComponent가 today와 일치하는지 검사
    func test_유효성검사() {
        dateFormatter.dateFormat = "dd"
        
        let dayComponent = DayComponent.allCases[calendar.component(.weekday, from: date) - 1]
        let dayValue = Int(dateFormatter.string(from: date))!

        XCTAssertEqual(WeekComponent(dayComponent: dayComponent, dayValue: dayValue), WeekComponent.today!, "WeekComponent.today가 올바르지 않음")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
