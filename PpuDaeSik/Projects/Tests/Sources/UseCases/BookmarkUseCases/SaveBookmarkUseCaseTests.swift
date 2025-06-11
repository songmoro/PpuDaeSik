//
//  SaveBookmarkUseCaseTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import UseCasesImpls
@testable import Entities

final class SaveBookmarkUseCaseTests: XCTestCase {
    func testSaveBookmarksCallsRepositoryWithCorrectValue() {
        let mock = BookmarkRepositoryMock()
        let useCase = SaveBookmarkUseCaseImpl(bookmarkRepository: mock)
        
        let bookmarks: [Cafeteria] = [.진리관, .샛벌회관식당]
        useCase.execute(bookmark: bookmarks)
        
        XCTAssertEqual(mock.savedBookmarks, bookmarks)
    }
}
