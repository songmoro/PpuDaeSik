//
//  BookmarkUseCasesImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//


import SwiftUI

// MARK: Provider
public struct BookmarkUseCasesImpl: BookmarkUseCases {
    public var action: ActionBookmarkUseCase
    public var save: SaveBookmarkUseCase
    public var load: LoadBookmarkUseCase
    
    public init(action: ActionBookmarkUseCase, save: SaveBookmarkUseCase, load: LoadBookmarkUseCase) {
        self.action = action
        self.save = save
        self.load = load
    }
}
//:-

// MARK: Impl
public struct ActionBookmarkUseCaseImpl: ActionBookmarkUseCase {
    public init() { }
    
    public func execute(bookmark: [Cafeteria], cafeteria: Cafeteria) -> [Cafeteria] {
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

public struct SaveBookmarkUseCaseImpl: SaveBookmarkUseCase {
    private let bookmarkRepository: BookmarkRepository
    
    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    public func execute(bookmark: [Cafeteria]) {
        bookmarkRepository.save(value: bookmark.map { $0.name })
    }
}

public struct LoadBookmarkUseCaseImpl: LoadBookmarkUseCase {
    private let bookmarkRepository: BookmarkRepository
    
    public init(bookmarkRepository: BookmarkRepository) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    public func execute() -> [Cafeteria] {
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
