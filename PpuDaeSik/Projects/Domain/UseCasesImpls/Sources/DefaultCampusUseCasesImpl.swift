//
//  DefaultCampusUseCasesImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Entities
import UseCases
import Repositories

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
        defaultCampusRepository.saveDefaultCampus(defaultCampus: defaultCampus)
    }
}

public struct LoadDefaultCampusUseCaseImpl: LoadDefaultCampusUseCase {
    private let defaultCampusRepository: DefaultCampusRepository
    
    public init(defaultCampusRepository: DefaultCampusRepository) {
        self.defaultCampusRepository = defaultCampusRepository
    }
    
    public func execute() -> Campus {
        let defaultCampus = defaultCampusRepository.loadDefaultCampus()
        
        if let defaultCampus = defaultCampus {
            return defaultCampus
        }
        else {
            return .부산
        }
    }
}
//:-
