//
//  StubCafeteriaUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Entities

// MARK: Stub
public struct StubCafeteriaUseCases: CafeteriaUseCases {
    public let fetch: FetchCafeteriaUseCase = StubFetchCafeteriaUseCaseImpl()
    public let load: LoadCafeteriaUseCase = StubLoadCafeteriaUseCaseImpl()
    public let save: SaveCafeteriaUseCase = StubSaveCafeteriaUseCaseImpl()
    public let order: OrderCafeteriaUseCase = StubOrderCafeteriaUseCaseImpl()
    public let filter: FilterCafeteriaUseCase = StubFilterCafeteriaUseCaseImpl()
    
    public init() { }
}

public struct StubFetchCafeteriaUseCaseImpl: FetchCafeteriaUseCase {
    public init() { }
    
    public func execute(campus: Campus) async -> [CafeteriaMenu] {
        return []
    }
}

public struct StubLoadCafeteriaUseCaseImpl: LoadCafeteriaUseCase {
    public init() { }
    
    public func execute(campus: Campus) -> [CafeteriaMenu]? {
        return []
    }
}

public struct StubSaveCafeteriaUseCaseImpl: SaveCafeteriaUseCase {
    public init() { }
    
    public func execute(campus: Campus, menus: [CafeteriaMenu]) {
        
    }
}

public struct StubOrderCafeteriaUseCaseImpl: OrderCafeteriaUseCase {
    public init() { }
    
    public func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria] {
        return []
    }
}

public struct StubFilterCafeteriaUseCaseImpl: FilterCafeteriaUseCase {
    public init() { }
    
    public func execute(menus: [CafeteriaMenu], campus: Campus, weekComponent: WeekComponent) -> [CafeteriaMenu] {
        return []
    }
}
//:-
