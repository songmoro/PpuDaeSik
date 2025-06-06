//
//  BookmarkUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Foundation
import Entities

// MARK: Provider
public protocol BookmarkUseCases {
    var action: ActionBookmarkUseCase { get }
    var save: SaveBookmarkUseCase { get }
    var load: LoadBookmarkUseCase { get }
}
//:-

// MARK: UseCase
public protocol ActionBookmarkUseCase {
    func execute(bookmark: [Cafeteria], cafeteria: Cafeteria) -> [Cafeteria]
}

public protocol SaveBookmarkUseCase {
    func execute(bookmark: [Cafeteria])
}

public protocol LoadBookmarkUseCase {
    func execute() -> [Cafeteria]
}
//:-
