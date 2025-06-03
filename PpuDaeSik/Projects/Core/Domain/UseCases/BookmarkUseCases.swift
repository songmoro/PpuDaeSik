//
//  BookmarkUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Foundation

// MARK: Provider
protocol BookmarkUseCases {
    var action: ActionBookmarkUseCase { get }
    var save: SaveBookmarkUseCase { get }
    var load: LoadBookmarkUseCase { get }
}
//:-

// MARK: UseCase
protocol ActionBookmarkUseCase {
    func execute(bookmark: [Cafeteria], cafeteria: Cafeteria) -> [Cafeteria]
}

protocol SaveBookmarkUseCase {
    func execute(bookmark: [Cafeteria])
}

protocol LoadBookmarkUseCase {
    func execute() -> [Cafeteria]
}
//:-
