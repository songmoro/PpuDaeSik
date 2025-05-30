//
//  StubBookmarkUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//


// MARK: Stub
struct StubBookmarkUseCases: BookmarkUseCases {
    var action: ActionBookmarkUseCase = StubActionBookmarkUseCaseImpl()
    var save: SaveBookmarkUseCase = StubSaveBookmarkUseCaseImpl()
    var load: LoadBookmarkUseCase = StubLoadBookmarkUseCaseImpl()
}

struct StubActionBookmarkUseCaseImpl: ActionBookmarkUseCase {
    func execute(bookmark: [Cafeteria], cafeteria: Cafeteria) -> [Cafeteria] {
        return []
    }
}

struct StubSaveBookmarkUseCaseImpl: SaveBookmarkUseCase {
    func execute(bookmark: [Cafeteria]) {
        
    }
}

struct StubLoadBookmarkUseCaseImpl: LoadBookmarkUseCase {
    func execute() -> [Cafeteria] {
        return []
    }
}
//:-
