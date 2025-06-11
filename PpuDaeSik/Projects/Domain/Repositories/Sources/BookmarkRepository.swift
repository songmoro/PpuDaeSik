//
//  BookmarkRepository.swift
//  Repositories
//
//  Created by 송재훈 on 6/6/25.
//

import Entities

public protocol BookmarkRepository {
    func saveBookmarks(_ bookmarks: [Cafeteria])
    func loadBookmarks() -> [Cafeteria]?
}
