//
//  DefaultCampusUseCasesImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

// MARK: Provider
public struct DefaultCampusUseCasesImpl: DefaultCampusUseCases {
    public var save: SaveDefaultCampusUseCase
    public var load: LoadDefaultCampusUseCase
    
    public init(save: SaveDefaultCampusUseCase, load: LoadDefaultCampusUseCase) {
        self.save = save
        self.load = load
    }
}
//:-

// MARK: Impl
public struct SaveDefaultCampusUseCaseImpl: SaveDefaultCampusUseCase {
    private let defaultCampusRepository: DefaultCampusRepository
    
    public init(defaultCampusRepository: DefaultCampusRepository) {
        self.defaultCampusRepository = defaultCampusRepository
    }
    
    public func execute(defaultCampus: Campus) {
        defaultCampusRepository.save(value: defaultCampus.rawValue)
    }
}

public struct LoadDefaultCampusUseCaseImpl: LoadDefaultCampusUseCase {
    private let defaultCampusRepository: DefaultCampusRepository
    
    public init(defaultCampusRepository: DefaultCampusRepository) {
        self.defaultCampusRepository = defaultCampusRepository
    }
    
    public func execute() -> Campus {
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
