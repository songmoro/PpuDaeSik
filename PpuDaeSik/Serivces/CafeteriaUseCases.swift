//
//  CafeteriaUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

// MARK: Provider
protocol CafeteriaUseCases {
    var update: UpdateCafeteriaUseCase { get }
    var cancleAll: CancleAllCafeteriaUseCase { get }
    var fetch: FetchCafeteriaUseCase { get }
    var checkDeployment: CheckDeploymentUseCase { get }
    var load: LoadCafeteriaUseCase { get }
    var save: SaveCafeteriaUseCase { get }
    var order: OrderCafeteriaUseCase { get }
    var filter: FilterCafeteriaUseCase { get }
}

struct CafeteriaUseCasesImpl: CafeteriaUseCases {
    let update: UpdateCafeteriaUseCase
    let cancleAll: CancleAllCafeteriaUseCase
    let fetch: FetchCafeteriaUseCase
    let checkDeployment: CheckDeploymentUseCase
    let load: LoadCafeteriaUseCase
    let save: SaveCafeteriaUseCase
    let order: OrderCafeteriaUseCase
    let filter: FilterCafeteriaUseCase
}
//:-

// MARK: Input
struct UpdateCafeteriaDataInput {
    var list: [Cafeteria]?
    var response: Loadable<[CafeteriaResponse]>?
    var filterByDay: [CafeteriaResponse]?
}
//:-


// MARK: UseCase
protocol UpdateCafeteriaUseCase {
    func execute(input: UpdateCafeteriaDataInput)
}

protocol CancleAllCafeteriaUseCase {
    func execute()
}

protocol FetchCafeteriaUseCase {
    func execute(isUpdating: Bool, campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse]
}

protocol CheckDeploymentUseCase {
    func execute(for type: DeploymentType) async -> Bool
}

protocol LoadCafeteriaUseCase {
    func execute(campus: Campus) -> [CafeteriaResponse]?
}

protocol SaveCafeteriaUseCase {
    func execute(campus: Campus, response: [CafeteriaResponse])
}

protocol OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria]
}

protocol FilterCafeteriaUseCase {
    func execute(response: Loadable<[CafeteriaResponse]>, campus: Campus, weekComponent: WeekComponent) -> [CafeteriaResponse]
}
//:-

// MARK: Impl
struct UpdateCafeteriaUseCaseImpl: UpdateCafeteriaUseCase {
    private let appState: Store<AppState>
    
    init(appState: Store<AppState>) {
        self.appState = appState
    }
    
    func execute(input: UpdateCafeteriaDataInput) {
        if let list = input.list {
            appState[\.cafeteria.list] = list
        }
        if let response = input.response {
            appState[\.cafeteria.response] = response
        }
        if let filterByDay = input.filterByDay {
            appState[\.cafeteria.filterByDay] = filterByDay
        }
    }
}

struct CancleAllCafeteriaUseCaseImpl: CancleAllCafeteriaUseCase {
    private let cafeteriaRepository: CafeteriaRepository
    
    init(cafeteriaRepository: CafeteriaRepository) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    func execute() {
        cafeteriaRepository.cancleAllRequest()
    }
}

struct FetchCafeteriaUseCaseImpl: FetchCafeteriaUseCase {
    private let cafeteriaRepository: CafeteriaRepository
    
    init(cafeteriaRepository: CafeteriaRepository) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    func execute(isUpdating: Bool, campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse] {
        let response: [CafeteriaResponse]
        
        switch type {
        case .restaurant:
            let restaurantResponse: RestaurantResponse = await cafeteriaRepository.fetch(NotionAPI.restaurant(campus: campus, isUpdating: isUpdating))
            response = restaurantResponse.convertToCafeteria()
        case .dormitory:
            let dormitoryResponse: DormitoryResponse = await cafeteriaRepository.fetch(NotionAPI.dormitory(campus: campus, isUpdating: isUpdating))
            response = dormitoryResponse.convertToCafeteria()
        }
        
        return response
    }
}

struct CheckDeploymentUseCaseImpl: CheckDeploymentUseCase {
    private let cafeteriaRepository: CafeteriaRepository
    
    init(cafeteriaRepository: CafeteriaRepository) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    func execute(for type: DeploymentType) async -> Bool {
        let response: NotionResponse<DeploymentProperties> = await cafeteriaRepository.fetch(NotionAPI.status(type: type))
        let deploymentStatus = Deployment(response: response.results.first!.properties)
        
        return deploymentStatus.isUpdating
    }
}

struct LoadCafeteriaUseCaseImpl: LoadCafeteriaUseCase {
    private let cacheRepositories: [Campus: CacheRepository]
    
    init(cacheRepositories: [Campus : CacheRepository]) {
        self.cacheRepositories = cacheRepositories
    }
    
    func execute(campus: Campus) -> [CafeteriaResponse]? {
        let cacheRepository = cacheRepositories[campus]
        guard let cacheRepository = cacheRepository else { return nil }
        
        let cachedResponse: Data? = cacheRepository.load()
        guard let cachedResponse = cachedResponse else { return nil }
        
        let decodedResponse = try? PropertyListDecoder().decode([CafeteriaResponse].self, from: cachedResponse)
        guard let decodedResponse = decodedResponse else { return nil }
        
        return decodedResponse
    }
}

struct SaveCafeteriaUseCaseImpl: SaveCafeteriaUseCase {
    private let cacheRepositories: [Campus: CacheRepository]
    
    init(cacheRepositories: [Campus : CacheRepository]) {
        self.cacheRepositories = cacheRepositories
    }
    
    func execute(campus: Campus, response: [CafeteriaResponse]) {
        let cacheRepository = cacheRepositories[campus]
        guard let cacheRepository = cacheRepository else { return }
        
        let encodedResponse = try? PropertyListEncoder().encode(response)
        guard let encodedResponse = encodedResponse else { return }
        
        cacheRepository.save(value: encodedResponse)
    }
}

struct OrderCafeteriaUseCaseImpl: OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria] {
        var newCafeteria: (bookmarked: [Cafeteria], unbookmarked: [Cafeteria]) = ([], [])
        
        Cafeteria.allCases.forEach {
            if campus != $0.campus { return }
            
            if bookmark.contains($0) { newCafeteria.bookmarked.append($0) }
            else { newCafeteria.unbookmarked.append($0) }
        }
        
        return newCafeteria.bookmarked + newCafeteria.unbookmarked
    }
}

struct FilterCafeteriaUseCaseImpl: FilterCafeteriaUseCase {
    func execute(response: Loadable<[CafeteriaResponse]>, campus: Campus, weekComponent: WeekComponent) -> [CafeteriaResponse] {
        if case .loaded(let allResponse) = response {
            let newResponse: [CafeteriaResponse]
            
            newResponse = allResponse.filter { response in
                guard let last = response.date.split(separator: "-").last,
                      let dayValue = Int(last),
                      weekComponent.dayValue == dayValue,
                      response.cafeteria.campus == campus
                else { return false }
                return true
            }
            
            return newResponse
        }
        else {
            return []
        }
    }
}
//:-

// MARK: Stub
struct StubCafeteriaUseCases: CafeteriaUseCases {
    let update: UpdateCafeteriaUseCase = StubUpdateCafeteriaUseCaseImpl()
    let cancleAll: CancleAllCafeteriaUseCase = StubCancleAllCafeteriaUseCaseImpl()
    let fetch: FetchCafeteriaUseCase = StubFetchCafeteriaUseCaseImpl()
    let checkDeployment: CheckDeploymentUseCase = StubCheckDeploymentUseCaseImpl()
    let load: LoadCafeteriaUseCase = StubLoadCafeteriaUseCaseImpl()
    let save: SaveCafeteriaUseCase = StubSaveCafeteriaUseCaseImpl()
    let order: OrderCafeteriaUseCase = StubOrderCafeteriaUseCaseImpl()
    let filter: FilterCafeteriaUseCase = StubFilterCafeteriaUseCaseImpl()
}

struct StubUpdateCafeteriaUseCaseImpl: UpdateCafeteriaUseCase {
    func execute(input: UpdateCafeteriaDataInput) {
        
    }
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
