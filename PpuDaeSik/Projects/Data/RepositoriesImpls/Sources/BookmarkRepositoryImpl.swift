//
//  BookmarkRepositoryImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import Foundation
import Entities
import Repositories

//public struct BookmarkRepository: UserDataRepository {
//    public let key: String
//    
//    public init(key: String) {
//        self.key = key
//    }
//}

public struct BookmarkRepositoryImpl: BookmarkRepository {
    private let key: String = "bookmark"
    public init() {}
    
    public func saveBookmarks(_ bookmarks: [Cafeteria]) {
        UserDefaults.standard.setValue(bookmarks.map({ $0.name }), forKey: key)
    }
    
    public func loadBookmarks() -> [Cafeteria]? {
        return UserDefaults.standard.value(forKey: key) as? [Cafeteria]
    }
}
