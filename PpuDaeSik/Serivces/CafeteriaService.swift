//
//  CafeteriaService.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

protocol CafeteriaService {
    /// 데이터베이스로부터 식당 목록을 불러오는 로직을 관리하는 함수
    func fetch()
}

struct CafeteriaServiceImpl: CafeteriaService {
    let appState: Store<AppState>
    
    func fetch() {
        RequestManager.shared.cancleAllRequest()
        
        let selectedCampus = appState[\.tab.campus]
        appState[\.cafeteria.response] = []
        
        Task {
            let queryTypeArray = await checkDatabaseStatus()
            
            let responses: [[CafeteriaResponse]] = await withTaskGroup(of: [CafeteriaResponse].self) { group in
                for queryType in queryTypeArray {
                    group.addTask {
                        await self.requestByCampusDatabase(selectedCampus, queryType)
                    }
                }
                
                var collectedResponses: [[CafeteriaResponse]] = []
                
                for await result in group {
                    collectedResponses.append(result)
                }
                
                return collectedResponses
            }
            
            let newCafeteriaResponse = responses.flatMap { $0 }
            
            DispatchQueue.main.async {
                appState[\.cafeteria.response] = newCafeteriaResponse
            }
        }
    }
    
    /// 데이터베이스가 백업 상태인지 검사하는 함수
    /// - QueryType:
    ///     - DB: 데이터베이스 종류(학생 식당, 기숙사)
    ///     - Status: 데이터베이스 백업 중 여부(백업, 완료)
    func checkDatabaseStatus() async -> [QueryType] {
        let response = await RequestManager.shared.request(.checkStatus, NotionResponse<DeploymentProperties>.self)
        guard let response = response else { return [] }
        
        let queryTypeArray: [QueryType] = response.results.compactMap {
            guard let queryType = QueryType($0.properties) else { return nil }
            return queryType
        }
        
        return queryTypeArray
    }
    
    /// 지정한 캠퍼스와 데이터베이스에 대한 데이터를 요청하는 함수
    /// - 캠퍼스: 부산, 밀양, 양산
    /// - 데이터베이스: 학생 식당, 기숙사
    func requestByCampusDatabase(_ campus: Campus, _ queryType: QueryType) async -> [CafeteriaResponse] {
        switch queryType {
        case .restaurant:
            let responseArray = await RequestManager.shared.request(
                .queryByCampus(queryType, campus),
                NotionResponse<RestaurantProperties>.self
            )
            
            guard let responseArray = responseArray else { return [] }
            
            return responseArray.results.compactMap {
                CafeteriaResponse(from: $0.properties.toDict())
            }
        case .domitory:
            let responseArray = await RequestManager.shared.request(
                .queryByCampus(queryType, campus),
                NotionResponse<DomitoryProperties>.self
            )
            
            guard let responseArray = responseArray else { return [] }
            
            return responseArray.results.compactMap {
                CafeteriaResponse(from: $0.properties.toDict())
            }
        }
    }
}

struct StubCafeteriaService: CafeteriaService {
    func fetch() { }
}
