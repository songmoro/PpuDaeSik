//
//  StubDefaultCampusUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

// MARK: Stub
struct StubDefaultCampusUseCases: DefaultCampusUseCases {
    var save: SaveDefaultCampusUseCase = StubSaveDefaultCampusUseCaseImpl()
    var load: LoadDefaultCampusUseCase = StubLoadDefaultCampusUseCaseImpl()
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
