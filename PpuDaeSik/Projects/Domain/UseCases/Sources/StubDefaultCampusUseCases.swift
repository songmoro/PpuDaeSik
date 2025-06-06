//
//  StubDefaultCampusUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Entities

// MARK: Stub
public struct StubDefaultCampusUseCases: DefaultCampusUseCases {
    public var save: SaveDefaultCampusUseCase = StubSaveDefaultCampusUseCaseImpl()
    public var load: LoadDefaultCampusUseCase = StubLoadDefaultCampusUseCaseImpl()
    
    public init() { }
}

struct StubSaveDefaultCampusUseCaseImpl: SaveDefaultCampusUseCase {
    func execute(defaultCampus: Campus) {
        
    }
}

struct StubLoadDefaultCampusUseCaseImpl: LoadDefaultCampusUseCase {
    func execute() -> Campus {
        return .부산
    }
}
//:-
