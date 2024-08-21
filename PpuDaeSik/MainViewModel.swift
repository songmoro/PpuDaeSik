//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    /// 모달 시트 여부
    @Published var isSheetShow = false
    /// 1주
    /// - 일, 월, 화, 수, 목, 금, 토
    /// - n, n+1, ..., n+5, n+6일
    @Published var weekArray: [Week] = []
    /// 네트워크 요청을 통해 받은 응답 목록
    @Published var cafeteriaResponseArray = [CafeteriaResponse]() {
        didSet {
            filterResponse()
        }
    }
    /// 응답 목록 중 캠퍼스, 요일이 일치하는 응답 목록
    @Published var selectedCafeteriaArray = [CafeteriaResponse]()
    /// 선택한 일에 대한 인트 값
    @Published var selectedDayComponent: Int = 1
    /// 선택한 캠퍼스
    @Published var selectedCampus: Campus = .부산 {
        didSet {
            checkDatabaseStatus()
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
    @Published var selectedDay: Day = .일 {
        didSet {
            selectedDayComponent = weekArray[selectedDay.weekday - 1].dayComponent
            filterResponse()
        }
    }
    
    init() {
        currentWeek()
        selectedDay = Day.today
        loadDefaultCampus()
        loadBookmark()
    }
    
    /// 오늘 날짜를 기준으로 이번 주를 계산하는 함수
    func currentWeek() {
        let calendar = Calendar()
        
        let weekArray = zip(Day.allCases, calendar.interval()).reduce(into: [Week]()) { partialResult, weekday in
            guard let date = calendar.date(byAdding: .day, value: weekday.1, to: Date()) else { return }
            
            let day = weekday.0
            let dayComponent = calendar.component(.day, from: date)
            
            partialResult += [Week(day: day, dayComponent: dayComponent)]
        }
        
        guard weekArray.count == 7, weekArray.map({ $0.day }) == Day.allCases else { return }
        
        self.weekArray = weekArray
    }
}

/// 데이터베이스
extension MainViewModel {
    /// 데이터베이스가 백업 상태인지 검사하는 함수
    func checkDatabaseStatus() {
        cafeteriaResponseArray = []
        
        RequestManager.shared.cancleAllRequest()
        RequestManager.shared.request(.checkStatus, NotionResponse<DeploymentProperties>.self) { status in
            status.results.forEach {
                guard let queryType = QueryType($0.properties) else { return }
                self.requestByCampusDatabase(self.selectedCampus, queryType)
            }
        }
    }
    
    /// 지정한 캠퍼스와 데이터베이스에 대한 데이터를 요청하는 함수
    /// - 캠퍼스: 부산, 밀양, 양산
    /// - 데이터베이스: 학생 식당, 기숙사
    func requestByCampusDatabase(_ campus: Campus, _ queryType: QueryType) {
        switch queryType {
        case .restaurant:
            RequestManager.shared.request(.queryByCampus(queryType, campus), NotionResponse<RestaurantProperties>.self) {
                self.cafeteriaResponseArray += $0.results.compactMap { result in
                    CafeteriaResponse(result.properties)
                }
            }
        case .domitory:
            RequestManager.shared.request(.queryByCampus(queryType, campus), NotionResponse<DomitoryProperties>.self) {
                self.cafeteriaResponseArray += $0.results.compactMap { result in
                    CafeteriaResponse(result.properties)
                }
            }
        }
    }
    
    /// 현재 선택된 캠퍼스에 맞는 응답 목록을 담는 함수
    func filterResponse() {
        selectedCafeteriaArray = []
        selectedCafeteriaArray = cafeteriaResponseArray.filter { response in
            guard let last = response.date.split(separator: "-").last,
                  let dayComponent = Int(last),
                  dayComponent == selectedDayComponent,
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
