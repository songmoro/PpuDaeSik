//
//  BookmarkRepositoryImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import Foundation
import Entities
import Repositories

public struct BookmarkRepositoryImpl: BookmarkRepository {
    private let key: String = "bookmark"
    public init() {}
    
    public func saveBookmarks(_ bookmarks: [Cafeteria]) {
        UserDefaults.standard.setValue(bookmarks.map({ $0.name }), forKey: key)
    }
    
    public func loadBookmarks() -> [Cafeteria]? {
        let bookmark = UserDefaults.standard.value(forKey: key) as? [String]
        
        let cafeteria: [Cafeteria]?
        if let bookmark = bookmark {
            cafeteria = Cafeteria.allCases.filter({ bookmark.contains($0.name) })
        }
        else {
            cafeteria = nil
        }
        
        return cafeteria
    }
}
