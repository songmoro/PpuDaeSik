//
//  BookmarkUseCasesImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//


import SwiftUI

// MARK: Provider
struct BookmarkUseCasesImpl: BookmarkUseCases {
    var action: ActionBookmarkUseCase
    var save: SaveBookmarkUseCase
    var load: LoadBookmarkUseCase
}
//:-

// MARK: Impl
struct ActionBookmarkUseCaseImpl: ActionBookmarkUseCase {
    func execute(bookmark: [Cafeteria], cafeteria: Cafeteria) -> [Cafeteria] {
        var bookmark = bookmark
        
        if bookmark.contains(cafeteria) {
            bookmark.removeAll { $0 == cafeteria }
        }
        else {
            bookmark.append(cafeteria)
        }
        
        return bookmark
    }
}

struct SaveBookmarkUseCaseImpl: SaveBookmarkUseCase {
    private let bookmarkRepository: BookmarkRepository
    
    init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    func execute(bookmark: [Cafeteria]) {
        bookmarkRepository.save(value: bookmark.map { $0.name })
    }
}

struct LoadBookmarkUseCaseImpl: LoadBookmarkUseCase {
    private let bookmarkRepository: BookmarkRepository
    
    init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    func execute() -> [Cafeteria] {
        let bookmark: [String]? = bookmarkRepository.load()
        
        if let bookmark = bookmark {
            return Cafeteria.allCases.filter({ bookmark.contains($0.name) })
        }
        else {
            return []
        }
    }
}
//:-
