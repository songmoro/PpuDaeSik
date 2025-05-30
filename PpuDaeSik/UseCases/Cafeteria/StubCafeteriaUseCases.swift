//
//  StubCafeteriaUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

// MARK: Stub
struct StubCafeteriaUseCases: CafeteriaUseCases {
    let cancleAll: CancleAllCafeteriaUseCase = StubCancleAllCafeteriaUseCaseImpl()
    let fetch: FetchCafeteriaUseCase = StubFetchCafeteriaUseCaseImpl()
    let checkDeployment: CheckDeploymentUseCase = StubCheckDeploymentUseCaseImpl()
    let load: LoadCafeteriaUseCase = StubLoadCafeteriaUseCaseImpl()
    let save: SaveCafeteriaUseCase = StubSaveCafeteriaUseCaseImpl()
    let order: OrderCafeteriaUseCase = StubOrderCafeteriaUseCaseImpl()
    let filter: FilterCafeteriaUseCase = StubFilterCafeteriaUseCaseImpl()
}

struct StubCancleAllCafeteriaUseCaseImpl: CancleAllCafeteriaUseCase {
    func execute() {
        
    }
}

struct StubFetchCafeteriaUseCaseImpl: FetchCafeteriaUseCase {
    func execute(isUpdating: Bool, campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse] {
        return []
    }
}

struct StubCheckDeploymentUseCaseImpl: CheckDeploymentUseCase {
    func execute(for type: DeploymentType) async -> Bool {
        return false
    }
}

struct StubLoadCafeteriaUseCaseImpl: LoadCafeteriaUseCase {
    func execute(campus: Campus) -> [CafeteriaResponse]? {
        return []
    }
}

struct StubSaveCafeteriaUseCaseImpl: SaveCafeteriaUseCase {
    func execute(campus: Campus, response: [CafeteriaResponse]) { }
}

struct StubOrderCafeteriaUseCaseImpl: OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria] {
        return []
    }
}

struct StubFilterCafeteriaUseCaseImpl: FilterCafeteriaUseCase {
    func execute(response: Loadable<[CafeteriaResponse]>, campus: Campus, weekComponent: WeekComponent) -> [CafeteriaResponse] {
        return []
    }
}
//:-
