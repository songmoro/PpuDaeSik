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
    
    func currentWeek() {
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            return calendar
        }()
        
        let interval = calendar.interval()
        
        let weekArray = zip(Day.allCases, interval).reduce(into: [Week]()) { partialResult, weekday in
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
    func checkDatabaseStatus() {
        cafeteriaResponseArray = []
        RequestManager.request(.checkStatus) { status in
            status.forEach {
                guard let DB = $0["DB"],
                      let queryType = QueryType(rawValue: DB),
                      let status = $0["Status"],
                      let deploymentStatus = DeploymentStatus(status: status)
                else { return }
                
                self.requestByCampusDatabase(self.selectedCampus, queryType, deploymentStatus)
            }
        }
    }
    
    func requestByCampusDatabase(_ campus: Campus, _ queryType: QueryType, _ deploymentStatus: DeploymentStatus) {
        RequestManager.request(.queryByCampus(queryType, campus, deploymentStatus), CafeteriaResponse.self) {
            self.cafeteriaResponseArray += $0
        }
    }
    
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
    
    func filterCafeteria() -> [Cafeteria] {
        let bookmarkedCafeteria = Cafeteria.allCases.filter({ bookmark.contains($0) })
        let unbookmarkedCafeteria = Cafeteria.allCases.filter({ !bookmark.contains($0) && $0.campus == selectedCampus })
        
        return bookmarkedCafeteria + unbookmarkedCafeteria
    }
}

/// 유저 디폴트
extension MainViewModel {
    func saveDefaultCampus() {
        UserDefaults.standard.setValue(defaultCampus.rawValue, forKey: "defaultCampus")
    }
    
    func saveBookmark() {
        UserDefaults.standard.setValue(bookmark.map({ $0.name }), forKey: "bookmark")
    }
    
    func loadDefaultCampus() {
        guard let storedCampus = UserDefaults.standard.string(forKey: "defaultCampus"), let campus =  Campus(storedCampus) else {
            defaultCampus = .부산
            selectedCampus = .부산
            return
        }
        
        defaultCampus = campus
        selectedCampus = campus
    }
    
    func loadBookmark() {
        guard let bookmark = UserDefaults.standard.stringArray(forKey: "bookmark") else {
            self.bookmark = []
            return
        }
        self.bookmark = Cafeteria.allCases.filter({ bookmark.contains($0.name) })
    }
}
