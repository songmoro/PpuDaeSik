//
//  DefaultCampusUseCasesImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

// MARK: Provider
struct DefaultCampusUseCasesImpl: DefaultCampusUseCases {
    var save: SaveDefaultCampusUseCase
    var load: LoadDefaultCampusUseCase
}
//:-

// MARK: Impl
struct SaveDefaultCampusUseCaseImpl: SaveDefaultCampusUseCase {
    private let defaultCampusRepository: DefaultCampusRepository
    
    init(defaultCampusRepository: DefaultCampusRepository) {
        self.defaultCampusRepository = defaultCampusRepository
    }
    
    func execute(defaultCampus: Campus) {
        defaultCampusRepository.save(value: defaultCampus.rawValue)
    }
}

struct LoadDefaultCampusUseCaseImpl: LoadDefaultCampusUseCase {
    private let defaultCampusRepository: DefaultCampusRepository
    
    init(defaultCampusRepository: DefaultCampusRepository) {
        self.defaultCampusRepository = defaultCampusRepository
    }
    
    func execute() -> Campus {
        let rawValue: String? = defaultCampusRepository.load()
        
        if let rawValue = rawValue, let defaultCampus = Campus(rawValue) {
            return defaultCampus
        }
        else {
            return .부산
        }
    }
}
//:-
