//
//  StubCafeteriaUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import Entities

// MARK: Stub
public struct StubCafeteriaUseCases: CafeteriaUseCases {
//    public let cancleAll: CancleAllCafeteriaUseCase = StubCancleAllCafeteriaUseCaseImpl()
    public let fetch: FetchCafeteriaUseCase = StubFetchCafeteriaUseCaseImpl()
//    public let checkDeployment: CheckDeploymentUseCase = StubCheckDeploymentUseCaseImpl()
    public let load: LoadCafeteriaUseCase = StubLoadCafeteriaUseCaseImpl()
    public let save: SaveCafeteriaUseCase = StubSaveCafeteriaUseCaseImpl()
    public let order: OrderCafeteriaUseCase = StubOrderCafeteriaUseCaseImpl()
    public let filter: FilterCafeteriaUseCase = StubFilterCafeteriaUseCaseImpl()
    
    public init() { }
}

//struct StubCancleAllCafeteriaUseCaseImpl: CancleAllCafeteriaUseCase {
//    func execute() {
//        
//    }
//}

struct StubFetchCafeteriaUseCaseImpl: FetchCafeteriaUseCase {
//    func execute(isUpdating: Bool, campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse] {
//        return []
//    }
    func execute(campus: Campus) async -> [CafeteriaMenu] {
        return []
    }
}

//struct StubCheckDeploymentUseCaseImpl: CheckDeploymentUseCase {
//    func execute(for type: DeploymentType) async -> Bool {
//        return false
//    }
//}

struct StubLoadCafeteriaUseCaseImpl: LoadCafeteriaUseCase {
//    func execute(campus: Campus) -> [CafeteriaResponse]? {
//        return []
//    }
    func execute(campus: Campus) -> [CafeteriaMenu]? {
        return []
    }
}

struct StubSaveCafeteriaUseCaseImpl: SaveCafeteriaUseCase {
//    func execute(campus: Campus, response: [CafeteriaResponse]) { }
    func execute(campus: Campus, menus: [CafeteriaMenu]) {
        
    }
}

struct StubOrderCafeteriaUseCaseImpl: OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria] {
        return []
    }
}

struct StubFilterCafeteriaUseCaseImpl: FilterCafeteriaUseCase {
//    func execute(response: Loadable<[CafeteriaResponse]>, campus: Campus, weekComponent: WeekComponent) -> [CafeteriaResponse] {
//        return []
//    }
    func execute(menus: [CafeteriaMenu], campus: Campus, weekComponent: WeekComponent) -> [CafeteriaMenu] {
        return []
    }
}
//:-
