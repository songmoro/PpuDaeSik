//
//  ActionBookmarkUseCaseTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import UseCasesImpls

final class ActionBookmarkUseCaseTests: XCTestCase {
    func testToggleBookmarkAddsItemIfNotExists() {
        let useCase = ActionBookmarkUseCaseImpl()
        let result = useCase.execute(bookmark: [.진리관], cafeteria: .금정회관학생식당)
        XCTAssertTrue(result.contains(.금정회관학생식당))
    }
    
    func testToggleBookmarkRemovesItemIfExists() {
        let useCase = ActionBookmarkUseCaseImpl()
        let result = useCase.execute(bookmark: [.진리관], cafeteria: .진리관)
        XCTAssertFalse(result.contains(.진리관))
    }
}
