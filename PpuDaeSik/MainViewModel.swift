//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedDay = ""
    @Published var isSheetShow = false
    @Published var weekday: [Week: Int] = [:]
    @Published var week: [Week: DateComponents] = [:]
    @Published var integratedResponseArray = [IntegratedResponse]()
    @Published var selectedCampus: Campus = .부산 {
        didSet {
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
    
    init() {
        currentWeek()
        selectedDay = Week.allCases[Calendar.current.component(.weekday, from: Date()) - 1].rawValue
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
        
        let week = interval.map {
            let date = calendar.date(byAdding: .day, value: $0, to: Date())

            return calendar.dateComponents([.year, .month, .day, .weekday], from: date!)
        }.compactMap({ $0 })
        
        
        self.week = Dictionary(uniqueKeysWithValues: zip(Week.allCases, week.sorted(by: { $0.weekday! < $1.weekday! })))
    }
    
    func sortedByBookmark() -> [String] {
        let exceptBookmark: [String] = IntegratedRestaurant.allCases.compactMap {
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
        self.integratedResponseArray = []
        
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
        RequestManager.request(.queryByCampus(queryType, campus, deploymentStatus), IntegratedResponse.self) {
            self.integratedResponseArray += $0
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
