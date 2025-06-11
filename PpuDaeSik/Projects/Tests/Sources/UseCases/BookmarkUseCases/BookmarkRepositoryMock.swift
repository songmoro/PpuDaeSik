//
//  BookmarkRepositoryMock.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import Entities
@testable import Repositories

final class BookmarkRepositoryMock: BookmarkRepository {
    var savedBookmarks: [Cafeteria]?
    var bookmarksToLoad: [Cafeteria]?
    
    func saveBookmarks(_ bookmarks: [Cafeteria]) {
        savedBookmarks = bookmarks
    }

    func loadBookmarks() -> [Cafeteria]? {
        return bookmarksToLoad
    }
}
