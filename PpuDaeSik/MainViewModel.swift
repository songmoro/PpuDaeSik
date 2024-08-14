//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedCampus = ""
    @Published var selectedDay = ""
    @Published var isSheetShow = false
    @Published var weekday: [Week: Int] = [:]
    @Published var week: [Week: DateComponents] = [:]
    @Published var defaultCampus = "부산"
    @Published var bookmark: [String] = []
    @Published var integratedResponseArray = [IntegratedResponse]()
    
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
    
    func checkDatabaseStatus() {
        RequestManager.request(.checkStatus) { status in
            status.forEach {
                if let DB = $0["DB"], let queryType = QueryType(rawValue: DB), let status = $0["Status"], let deploymentStatus = DeploymentStatus(status: status) {
                    self.requestByCampusDatabase(Campus(rawValue: self.selectedCampus)!, queryType, deploymentStatus)
                }
            }
        }
    }
    
    func requestByCampusDatabase(_ campus: Campus, _ queryType: QueryType, _ deploymentStatus: DeploymentStatus) {
        RequestManager.request(.queryByCampus(queryType, campus, deploymentStatus), IntegratedResponse.self) {
            self.integratedResponseArray += $0
            self.integratedResponseArray.removeAll { response in
                self.integratedResponseArray.filter({ response.content == $0.content && response.category == $0.category && response.restaurant == $0.restaurant }).count != 1
            }
        }
    }
    
    func sortedByBookmark() -> [String] {
        return bookmark + IntegratedRestaurant.allCases.filter({ !bookmark.contains($0.name) && $0.campus.rawValue == self.selectedCampus }).map({ $0.name })
    }
    
    func saveDefaultCampus() {
        UserDefaults.standard.setValue(defaultCampus, forKey: "defaultCampus")
    }
    
    func saveBookmark() {
        UserDefaults.standard.setValue(bookmark, forKey: "bookmark")
    }
    
    func loadDefaultCampus() {
        guard let campus = UserDefaults.standard.string(forKey: "defaultCampus") else {
            defaultCampus = "부산"
            selectedCampus = "부산"
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
