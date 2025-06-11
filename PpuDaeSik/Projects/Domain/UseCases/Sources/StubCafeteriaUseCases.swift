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

struct StubFetchCafeteriaUseCaseImpl: FetchCafeteriaUseCase {
    func execute(campus: Campus) async -> [CafeteriaMenu] {
        return []
    }
}

struct StubLoadCafeteriaUseCaseImpl: LoadCafeteriaUseCase {
    func execute(campus: Campus) -> [CafeteriaMenu]? {
        return []
    }
}

struct StubSaveCafeteriaUseCaseImpl: SaveCafeteriaUseCase {
    func execute(campus: Campus, menus: [CafeteriaMenu]) {
        
    }
}

struct StubOrderCafeteriaUseCaseImpl: OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria] {
        return []
    }
}

struct StubFilterCafeteriaUseCaseImpl: FilterCafeteriaUseCase {
    func execute(menus: [CafeteriaMenu], campus: Campus, weekComponent: WeekComponent) -> [CafeteriaMenu] {
        return []
    }
}
//:-
