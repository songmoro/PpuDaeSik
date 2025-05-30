//
//  DefaultCampusUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Foundation

// MARK: Provider
protocol DefaultCampusUseCases {
    var save: SaveDefaultCampusUseCase { get }
    var load: LoadDefaultCampusUseCase { get }
}
//:-

// MARK: UseCases
protocol SaveDefaultCampusUseCase {
    func execute(defaultCampus: Campus)
}

protocol LoadDefaultCampusUseCase {
    func execute() -> Campus
}
//:-
