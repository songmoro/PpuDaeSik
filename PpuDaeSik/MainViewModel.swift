//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    /// 필터링한 식당 응답 목록
    @Published var filteredCafeteriaResponseArray: [CafeteriaResponse] = []
    /// 진행 중인 네트워크 요청 수
    @Published var onFetchCount: Int = 0
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
    /// 현재 선택된 요일
    @Published var selectedWeekComponent: WeekComponent? = .today {
        didSet {
            filterResponse()
        }
    }
    /// 네트워크 요청을 통해 받은 응답 목록
    @Published var cafeteriaResponseArray = [CafeteriaResponse]()
    
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
        
        // TODO: async await으로 컴플리션 핸들러 중첩 줄이기
        self.onFetchCount = 1
        
        checkDatabaseStatus { queryTypeArray in
            self.onFetchCount -= 1
            
            queryTypeArray.forEach { queryType in
                self.onFetchCount += 1
                
                self.requestByCampusDatabase(self.selectedCampus, queryType) {
                    self.cafeteriaResponseArray += $0
                    self.onFetchCount -= 1
                }
            }
        }
    }
    
    /// 데이터베이스가 백업 상태인지 검사하는 함수
    /// - QueryType:
    ///     - DB: 데이터베이스 종류(학생 식당, 기숙사)
    ///     - Status: 데이터베이스 백업 중 여부(백업, 완료)
    func checkDatabaseStatus(completion: @escaping ([QueryType]) -> (Void)) {
        RequestManager.shared.request(.checkStatus, NotionResponse<DeploymentProperties>.self) { response in
            let queryTypeArray: [QueryType] = response.results.compactMap {
                guard let queryType = QueryType($0.properties) else { return nil }
                return queryType
            }
            
            completion(queryTypeArray)
        }
    }
    
    /// 지정한 캠퍼스와 데이터베이스에 대한 데이터를 요청하는 함수
    /// - 캠퍼스: 부산, 밀양, 양산
    /// - 데이터베이스: 학생 식당, 기숙사
    func requestByCampusDatabase(_ campus: Campus, _ queryType: QueryType, completion: @escaping ([CafeteriaResponse]) -> (Void)) {
        switch queryType {
        case .restaurant:
            RequestManager.shared.request(.queryByCampus(queryType, campus), NotionResponse<RestaurantProperties>.self) {
                let cafeteriaResponseArray = $0.results.compactMap { result in
                    CafeteriaResponse(result.properties)
                }
                
                completion(cafeteriaResponseArray)
            }
        case .domitory:
            RequestManager.shared.request(.queryByCampus(queryType, campus), NotionResponse<DomitoryProperties>.self) {
                let cafeteriaResponseArray = $0.results.compactMap { result in
                    CafeteriaResponse(result.properties)
                }
                
                completion(cafeteriaResponseArray)
            }
        }
    }
    
    /// 현재 선택된 캠퍼스에 맞는 응답 목록을 담는 함수
    func filterResponse() {
        self.filteredCafeteriaResponseArray = cafeteriaResponseArray.filter { response in
            guard let last = response.date.split(separator: "-").last,
                  let dayValue = Int(last),
                  selectedWeekComponent?.dayValue == dayValue,
                  response.cafeteria.campus == selectedCampus
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
