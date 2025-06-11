//
//  LoadBookmarkUseCaseTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import UseCasesImpls

final class LoadBookmarkUseCaseTests: XCTestCase {
    func testLoadBookmarkReturnsValueIfExists() {
        let mock = BookmarkRepositoryMock()
        mock.bookmarksToLoad = [.진리관, .금정회관학생식당]
        let useCase = LoadBookmarkUseCaseImpl(bookmarkRepository: mock)
        
        let result = useCase.execute()
        
        XCTAssertEqual(result, [.진리관, .금정회관학생식당])
    }
    
    func testLoadBookmarkReturnsEmptyIfNil() {
        let mock = BookmarkRepositoryMock()
        mock.bookmarksToLoad = nil
        let useCase = LoadBookmarkUseCaseImpl(bookmarkRepository: mock)
        
        let result = useCase.execute()
        
        XCTAssertEqual(result, [])
    }
}
