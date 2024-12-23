//
//  CafeteriaService.swift
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
