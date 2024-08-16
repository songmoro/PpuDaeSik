//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isSheetShow = false
    @Published var weekArray: [Week] = []
    @Published var cafeteriaResponseArray = [CafeteriaResponse]()
    @Published var selectedCampus: Campus = .부산 {
        didSet {
            cafeteriaResponseArray = []
            checkDatabaseStatus()
        }
    }
    @Published var defaultCampus: Campus = .부산 {
        didSet {
            saveDefaultCampus()
        }
    }
    @Published var bookmark: [String] = [] {
        didSet {
            saveBookmark()
        }
    }
    @Published var selectedDay: Day = .일
    // TODO: currentCafeteriaArray 만들어서 selectedDay, selectedCampus에 따른 계산된 변수 만들어주기.
    
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
    
    func sortedByBookmark() -> [String] {
        let exceptBookmark: [String] = Cafeteria.allCases.compactMap {
            if !bookmark.contains($0.name) && $0.campus == self.selectedCampus {
                return $0.name
            }
            return nil
        }
              
        return bookmark + exceptBookmark
    }
}

/// 데이터베이스
extension MainViewModel {
    func checkDatabaseStatus() {
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
}

/// 유저 디폴트
extension MainViewModel {
    func saveDefaultCampus() {
        UserDefaults.standard.setValue(defaultCampus.rawValue, forKey: "defaultCampus")
    }
    
    func saveBookmark() {
        UserDefaults.standard.setValue(bookmark, forKey: "bookmark")
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
        self.bookmark = bookmark
    }
}
