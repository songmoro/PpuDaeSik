//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    /// 현재 선택된 요일
    @Published var selectedWeekComponent: WeekComponent? = .today
    /// 네트워크 요청을 통해 받은 응답 목록
    @Published var cafeteriaResponseArray = [CafeteriaResponse]()
    /// 모달 시트 여부
    @Published var isSheetShow = false
    /// 선택한 캠퍼스
    @Published var selectedCampus: Campus = .부산 {
        didSet {
            fetchCafeteriaArray()
        }
    }
    /// 사용자가 설정한 앱 시작 시 기본으로 보여줄 캠퍼스
    @Published var defaultCampus: Campus = .부산 {
        didSet {
            saveDefaultCampus()
        }
    }
    /// 사용자가 설정한 앱 시작 시 먼저 보여줄 식당 목록
    @Published var bookmark: [Cafeteria] = [] {
        didSet {
            saveBookmark()
        }
    }
    
    init() {
        loadDefaultCampus()
        loadBookmark()
    }
}

/// 데이터베이스
extension MainViewModel {
    /// 데이터베이스로부터 식당 목록을 불러오는 로직을 관리하는 함수
    func fetchCafeteriaArray() {
        cafeteriaResponseArray = []
        RequestManager.shared.cancleAllRequest()
        
        Task {
            let queryTypeArray = await checkDatabaseStatus()
            for queryType in queryTypeArray {
                let responseArray = await requestByCampusDatabase(selectedCampus, queryType)
                
                DispatchQueue.main.async {
                    self.cafeteriaResponseArray += responseArray
                }
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
    
    /// 현재 선택된 캠퍼스에 맞는 응답 목록을 담는 함수
    func filterResponse() -> [CafeteriaResponse] {
        self.cafeteriaResponseArray.filter { response in
            guard let last = response.date.split(separator: "-").last,
                  let dayValue = Int(last),
                  self.selectedWeekComponent?.dayValue == dayValue,
                  response.cafeteria.campus == self.selectedCampus
            else { return false }
            return true
        }
    }
    
    /// 현재 선택된 캠퍼스에 있는 식당을 반환하는 함수
    func filterCafeteria() -> [Cafeteria] {
        let bookmarkedCafeteria = Cafeteria.allCases.filter({ bookmark.contains($0) && $0.campus == selectedCampus })
        let unbookmarkedCafeteria = Cafeteria.allCases.filter({ !bookmark.contains($0) && $0.campus == selectedCampus })
        
        return bookmarkedCafeteria + unbookmarkedCafeteria
    }
}

/// 유저 디폴트
extension MainViewModel {
    /// 설정에서 지정한 기본 캠퍼스의 유저 디폴트를 저장하는 함수
    func saveDefaultCampus() {
        UserDefaults.standard.setValue(defaultCampus.rawValue, forKey: "defaultCampus")
    }
    
    /// 북마크가 변경되었을 때 변경된 북마크를 저장하는 함수
    func saveBookmark() {
        UserDefaults.standard.setValue(bookmark.map({ $0.name }), forKey: "bookmark")
    }
    
    /// 앱 시작 시 기본 캠퍼스를 불러오는 함수
    func loadDefaultCampus() {
        guard let storedCampus = UserDefaults.standard.string(forKey: "defaultCampus"), let campus =  Campus(storedCampus) else {
            defaultCampus = .부산
            selectedCampus = .부산
            return
        }
        
        defaultCampus = campus
        selectedCampus = campus
    }
    
    /// 앱 시작 시 북마크된 식당을 불러오는 함수
    func loadBookmark() {
        guard let bookmark = UserDefaults.standard.stringArray(forKey: "bookmark") else {
            self.bookmark = []
            return
        }
        self.bookmark = Cafeteria.allCases.filter({ bookmark.contains($0.name) })
    }
}
