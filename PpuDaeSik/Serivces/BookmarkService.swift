//
//  BookmarkService.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import Foundation

protocol BookmarkService {
    func isBookmarked(_ cafeteria: Cafeteria) -> Bool
    func action(cafeteria: Cafeteria)
    func save(bookmark: [Cafeteria])
    func loadBookmark()
}

struct BookmarkServiceImpl: BookmarkService {
    let appState: Store<AppState>
    let bookmarkRepository: BookmarkRepository
    
    func isBookmarked(_ cafeteria: Cafeteria) -> Bool {
        appState[\.userData.bookmark].contains(cafeteria)
    }
    
    func action(cafeteria: Cafeteria) {
        var bookmark = appState[\.userData.bookmark]
        
        if bookmark.contains(cafeteria) {
            bookmark.removeAll { $0 == cafeteria }
        }
        else {
            bookmark.append(cafeteria)
        }
        
        save(bookmark: bookmark)
        loadBookmark()
    }
    
    /// 북마크를 저장하는 함수
    func save(bookmark: [Cafeteria]) {
        bookmarkRepository.save(value: bookmark.map { $0.name })
    }
    
    /// 북마크된 식당을 불러오는 함수
    func loadBookmark() {
        let bookmark: [String]? = bookmarkRepository.load()
        
        if let bookmark = bookmark {
            appState[\.userData.bookmark] = Cafeteria.allCases.filter({ bookmark.contains($0.name) })
        }
        else {
            appState[\.userData.bookmark] = []
        }
    }
}

struct StubBookmarkService: BookmarkService {
    func isBookmarked(_ cafeteria: Cafeteria) -> Bool { false }
    func action(cafeteria: Cafeteria) { }
    func save(bookmark: [Cafeteria]) { }
    func loadBookmark() { }
}
