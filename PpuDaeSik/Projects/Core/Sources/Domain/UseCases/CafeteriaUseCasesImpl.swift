//
//  CafeteriaUseCasesImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import SwiftUI
import Shared

// MARK: Provider
public struct CafeteriaUseCasesImpl: CafeteriaUseCases {
    public let cancleAll: CancleAllCafeteriaUseCase
    public let fetch: FetchCafeteriaUseCase
    public let checkDeployment: CheckDeploymentUseCase
    public let load: LoadCafeteriaUseCase
    public let save: SaveCafeteriaUseCase
    public let order: OrderCafeteriaUseCase
    public let filter: FilterCafeteriaUseCase
    
    public init(cancleAll: CancleAllCafeteriaUseCase, fetch: FetchCafeteriaUseCase, checkDeployment: CheckDeploymentUseCase, load: LoadCafeteriaUseCase, save: SaveCafeteriaUseCase, order: OrderCafeteriaUseCase, filter: FilterCafeteriaUseCase) {
        self.cancleAll = cancleAll
        self.fetch = fetch
        self.checkDeployment = checkDeployment
        self.load = load
        self.save = save
        self.order = order
        self.filter = filter
    }
}
//:-

// MARK: Impl
public struct CancleAllCafeteriaUseCaseImpl: CancleAllCafeteriaUseCase {
    private let cafeteriaRepository: CafeteriaRepositoryProtocol
    
    public init(cafeteriaRepository: CafeteriaRepositoryProtocol) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    public func execute() {
        cafeteriaRepository.cancleAllRequest()
    }
}

public struct FetchCafeteriaUseCaseImpl: FetchCafeteriaUseCase {
    private let cafeteriaRepository: CafeteriaRepositoryProtocol
    
    public init(cafeteriaRepository: CafeteriaRepositoryProtocol) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    public func execute(isUpdating: Bool, campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse] {
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

public struct CheckDeploymentUseCaseImpl: CheckDeploymentUseCase {
    private let cafeteriaRepository: CafeteriaRepositoryProtocol
    
    public init(cafeteriaRepository: CafeteriaRepositoryProtocol) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    public func execute(for type: DeploymentType) async -> Bool {
        let response: NotionResponse<DeploymentProperties> = await cafeteriaRepository.fetch(NotionAPI.status(type: type))
        let deploymentStatus = Deployment(response: response.results.first!.properties)
        
        return deploymentStatus.isUpdating
    }
}

public struct LoadCafeteriaUseCaseImpl: LoadCafeteriaUseCase {
    private let cacheRepositories: [Campus: CacheRepository]
    
    public init(cacheRepositories: [Campus : CacheRepository]) {
        self.cacheRepositories = cacheRepositories
    }
    
    public func execute(campus: Campus) -> [CafeteriaResponse]? {
        let cacheRepository = cacheRepositories[campus]
        guard let cacheRepository = cacheRepository else { return nil }
        
        let cachedResponse: Data? = cacheRepository.load()
        guard let cachedResponse = cachedResponse else { return nil }
        
        let decodedResponse = try? PropertyListDecoder().decode([CafeteriaResponse].self, from: cachedResponse)
        guard let decodedResponse = decodedResponse else { return nil }
        
        return decodedResponse
    }
}

public struct SaveCafeteriaUseCaseImpl: SaveCafeteriaUseCase {
    private let cacheRepositories: [Campus: CacheRepository]
    
    public init(cacheRepositories: [Campus : CacheRepository]) {
        self.cacheRepositories = cacheRepositories
    }
    
    public func execute(campus: Campus, response: [CafeteriaResponse]) {
        let cacheRepository = cacheRepositories[campus]
        guard let cacheRepository = cacheRepository else { return }
        
        let encodedResponse = try? PropertyListEncoder().encode(response)
        guard let encodedResponse = encodedResponse else { return }
        
        cacheRepository.save(value: encodedResponse)
    }
}

public struct OrderCafeteriaUseCaseImpl: OrderCafeteriaUseCase {
    public init() { }
    
    public func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria] {
        var newCafeteria: (bookmarked: [Cafeteria], unbookmarked: [Cafeteria]) = ([], [])
        
        Cafeteria.allCases.forEach {
            if campus != $0.campus { return }
            
            if bookmark.contains($0) { newCafeteria.bookmarked.append($0) }
            else { newCafeteria.unbookmarked.append($0) }
        }
        
        return newCafeteria.bookmarked + newCafeteria.unbookmarked
    }
}

public struct FilterCafeteriaUseCaseImpl: FilterCafeteriaUseCase {
    public init() { }
    
    public func execute(response: Loadable<[CafeteriaResponse]>, campus: Campus, weekComponent: WeekComponent) -> [CafeteriaResponse] {
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
