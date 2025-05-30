//
//  CafeteriaUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

protocol CafeteriaService {
    /// 현재 선택된 캠퍼스에 맞는 응답 목록을 담는 함수
    func refreshResponse()
    /// 현재 선택된 캠퍼스에 있는 식당을 갱신하는 함수
    func refreshCampusCafeteria()
    /// 데이터베이스로부터 식당 목록을 불러오는 로직을 관리하는 함수
    func fetch()
}

struct CafeteriaServiceImpl: CafeteriaService {
    let appState: Store<AppState>
    let cafeteriaRepository: CafeteriaRepository
    let cacheRepositories: [Campus: CacheRepository]
    
    func loadResponse() -> [CafeteriaResponse]? {
        let selectedCampus = appState[\.tab.campus]
        
        let cacheRepository = cacheRepositories[selectedCampus]
        guard let cacheRepository = cacheRepository else { return nil }
        
        let cachedResponse: Data? = cacheRepository.load()
        guard let cachedResponse = cachedResponse else { return nil }
        
        let decodedResponse = try? PropertyListDecoder().decode([CafeteriaResponse].self, from: cachedResponse)
        guard let decodedResponse = decodedResponse else { return nil }
        
        return decodedResponse
    }
    
    func save(response: [CafeteriaResponse]) {
        let selectedCampus = appState[\.tab.campus]
        
        let cacheRepository = cacheRepositories[selectedCampus]
        guard let cacheRepository = cacheRepository else { return }
        
        let encodedResponse = try? PropertyListEncoder().encode(response)
        guard let encodedResponse = encodedResponse else { return }
        
        cacheRepository.save(value: encodedResponse)
    }
    
    func refreshCampusCafeteria() {
        appState[\.cafeteria.list] = []
        
        let bookmark = appState[\.userData.bookmark]
        let selectedCampus = appState[\.tab.campus]
        
        var newCafeteria: (bookmarked: [Cafeteria], unbookmarked: [Cafeteria]) = ([], [])
        
        Cafeteria.allCases.forEach {
            if selectedCampus != $0.campus { return }
            
            if bookmark.contains($0) { newCafeteria.bookmarked.append($0) }
            else { newCafeteria.unbookmarked.append($0) }
        }
        
        appState[\.cafeteria.list] = newCafeteria.bookmarked + newCafeteria.unbookmarked
    }
    
    func refreshResponse() {
        if case .loaded(let allResponse) = appState[\.cafeteria.response] {
            let newResponse: [CafeteriaResponse]
            let weekComponent = appState[\.tab.weekComponent]
            let campus = appState[\.tab.campus]
            
            newResponse = allResponse.filter { response in
                guard let last = response.date.split(separator: "-").last,
                      let dayValue = Int(last),
                      weekComponent.dayValue == dayValue,
                      response.cafeteria.campus == campus
                else { return false }
                return true
            }
            
            appState[\.cafeteria.filterByDay] = newResponse
        }
    }
    
    func fetch() {
        appState[\.cafeteria.response].setIsLoading()
        appState[\.cafeteria.filterByDay] = []
        
        let cachedResponse = loadResponse()
        if let cachedResponse = cachedResponse {
            appState[\.cafeteria.response] = .loaded(cachedResponse)
        }
        
        Task {
            cafeteriaRepository.cancleAllRequest()
            
            let selectedCampus = appState[\.tab.campus]
            async let restaurantResponse = await requestBy(selectedCampus, for: .restaurant)
            async let dormitoryResponse = await requestBy(selectedCampus, for: .dormitory)
            let newCafeteriaResponse = await restaurantResponse + dormitoryResponse
            
            let responseCampus = appState[\.tab.campus]
            if cachedResponse != newCafeteriaResponse, selectedCampus == responseCampus {
                DispatchQueue.main.async {
                    appState[\.cafeteria.response] = .loaded(newCafeteriaResponse)
                }
                
                save(response: newCafeteriaResponse)
            }
        }
    }
    
    func checkDeployment(for type: DeploymentType) async -> Bool {
        let response: NotionResponse<DeploymentProperties> = await cafeteriaRepository.fetch(NotionAPI.status(type: type))
        let deploymentStatus = Deployment(response: response.results.first!.properties)
        
        return deploymentStatus.isUpdating
    }
    
    func requestBy(_ campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse] {
        let isUpdating = await checkDeployment(for: type)
        
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

struct StubCafeteriaService: CafeteriaService {
    func refreshResponse() { }
    func refreshCampusCafeteria() { }
    func fetch() { }
}

// MARK: Provider
protocol CafeteriaUseCases {
    var update: UpdateCafeteriaUseCase { get }
    var fetch: FetchCafeteriaUseCase { get }
    var checkDeployment: CheckDeploymentUseCase { get }
    var load: LoadCafeteriaUseCase { get }
    var save: SaveCafeteriaUseCase { get }
    var order: OrderCafeteriaUseCase { get }
}

struct CafeteriaUseCasesImpl: CafeteriaUseCases {
    var update: UpdateCafeteriaUseCase
    let fetch: FetchCafeteriaUseCase
    let checkDeployment: CheckDeploymentUseCase
    let load: LoadCafeteriaUseCase
    let save: SaveCafeteriaUseCase
    let order: OrderCafeteriaUseCase
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
//:-

// MARK: Stub
struct StubCafeteriaUseCases: CafeteriaUseCases {
    let update: UpdateCafeteriaUseCase = StubUpdateCafeteriaUseCaseImpl()
    let fetch: FetchCafeteriaUseCase = StubFetchCafeteriaUseCaseImpl()
    let checkDeployment: CheckDeploymentUseCase = StubCheckDeploymentUseCaseImpl()
    let load: LoadCafeteriaUseCase = StubLoadCafeteriaUseCaseImpl()
    let save: SaveCafeteriaUseCase = StubSaveCafeteriaUseCaseImpl()
    let order: OrderCafeteriaUseCase = StubOrderCafeteriaUseCaseImpl()
}

struct StubUpdateCafeteriaUseCaseImpl: UpdateCafeteriaUseCase {
    func execute(input: UpdateCafeteriaDataInput) {
        
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
//:-
