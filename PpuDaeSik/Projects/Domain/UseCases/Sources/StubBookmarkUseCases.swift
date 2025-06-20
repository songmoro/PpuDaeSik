//
//  StubBookmarkUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Entities

// MARK: Stub
public struct StubBookmarkUseCases: BookmarkUseCases {
    public var action: ActionBookmarkUseCase = StubActionBookmarkUseCaseImpl()
    public var save: SaveBookmarkUseCase = StubSaveBookmarkUseCaseImpl()
    public var load: LoadBookmarkUseCase = StubLoadBookmarkUseCaseImpl()
    
    public init() { }
}

public struct StubActionBookmarkUseCaseImpl: ActionBookmarkUseCase {
    public init() { }
    
    public func execute(bookmark: [Cafeteria], cafeteria: Cafeteria) -> [Cafeteria] {
        return []
    }
}

public struct StubSaveBookmarkUseCaseImpl: SaveBookmarkUseCase {
    public init() { }
    
    public func execute(bookmark: [Cafeteria]) {
        
    }
}

public struct StubLoadBookmarkUseCaseImpl: LoadBookmarkUseCase {
    public func execute() -> [Cafeteria] {
        return []
    }
}
//:-
