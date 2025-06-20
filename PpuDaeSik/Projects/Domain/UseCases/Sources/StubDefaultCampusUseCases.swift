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

public struct StubSaveDefaultCampusUseCaseImpl: SaveDefaultCampusUseCase {
    public init() { }
    
    public func execute(defaultCampus: Campus) {
        
    }
}

public struct StubLoadDefaultCampusUseCaseImpl: LoadDefaultCampusUseCase {
    public init() { }
    
    public func execute() -> Campus {
        return .부산
    }
}
//:-
