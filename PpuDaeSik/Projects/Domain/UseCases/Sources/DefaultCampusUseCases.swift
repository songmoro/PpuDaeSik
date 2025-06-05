//
//  DefaultCampusUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Foundation

// MARK: Provider
public protocol DefaultCampusUseCases {
    var save: SaveDefaultCampusUseCase { get }
    var load: LoadDefaultCampusUseCase { get }
}
//:-

// MARK: UseCases
public protocol SaveDefaultCampusUseCase {
    func execute(defaultCampus: Campus)
}

public protocol LoadDefaultCampusUseCase {
    func execute() -> Campus
}
//:-
