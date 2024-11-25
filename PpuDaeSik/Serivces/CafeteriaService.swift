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
        let newResponse: [CafeteriaResponse]
        let weekComponent = appState[\.tab.weekComponent]
        let campus = appState[\.tab.campus]
        
        newResponse = appState[\.cafeteria.response].filter { response in
            guard let last = response.date.split(separator: "-").last,
                  let dayValue = Int(last),
                  weekComponent?.dayValue == dayValue,
                  response.cafeteria.campus == campus
            else { return false }
            return true
        }
        
        appState[\.cafeteria.filterByDay] = newResponse
    }
    
    func fetch() {
        let selectedCampus = appState[\.tab.campus]
        appState[\.cafeteria.response] = []
        
        Task {
            async let restaurantResponse = await requestBy(selectedCampus, for: .restaurant)
            async let dormitoryResponse = await requestBy(selectedCampus, for: .dormitory)
            
            let newCafeteriaResponse = await restaurantResponse + dormitoryResponse
            
            DispatchQueue.main.async {
                appState[\.cafeteria.response] = newCafeteriaResponse
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
