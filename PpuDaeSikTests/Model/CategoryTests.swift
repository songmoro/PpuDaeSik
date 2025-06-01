//
//  CategoryTests.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 12/17/24.
//

import XCTest
import SwiftUI
@testable import PpuDaeSik

final class CategoryTests: XCTestCase {
    typealias Category = PpuDaeSik.Category
    
    func test_카테고리_init() {
        // Arrange
        let rawValues: [String] = ["01", "02", "B", "03", "L", "04", "D"]
        let expected: [Category] = [.조기, .조식, .조식, .중식, .중식, .석식, .석식]
        
        // Act
        let categories: [Category] = rawValues.compactMap {
            Category($0)
        }
        
        // Assert
        XCTAssertTrue(expected == categories, "카테고리 초기화 실패")
    }
    
    func test_unknown_카테고리_init() {
        // Arrange
        let rawValues: [String] = ["00", "05"]
        let expected: [Category] = []
        
        // Act
        let categories: [Category] = rawValues.compactMap {
            Category($0)
        }
        
        // Assert
        XCTAssertTrue(expected == categories, "알 수 없는 카테고리")
    }
    
    func test_카테고리_정렬() {
        // Arrange
        let categories: [Category] = [.중식, .석식, .조기, .조식]
        let expected: [Category] = [.조기, .조식, .중식, .석식]
        
        // Act
        let sortedCategories: [Category] = categories.sorted()
        
        // Assert
        XCTAssertTrue(expected == sortedCategories, "카테고리 정렬이 일치하지 않음")
    }
}
