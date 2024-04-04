//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI
import Moya

class MainViewModel: ObservableObject {
    @Published var selectedCampus = ""
    @Published var selectedDay = ""
    @Published var isSheetShow = false
    @Published var weekday: [Week: Int] = [:]
    @Published var defaultCampus = "부산"
    @Published var bookmark: [String] = []
    @Published var newRestaurant = [NewRestaurantResponse]()
    @Published var domitory = [DomitoryResponse]()
    
    func currentWeek() {
        var week: [Week: Int] = [:]
        let current = Calendar.current
        
        if let weekend = current.nextWeekend(startingAfter: Date())?.end {
            for (weekday, interval) in zip(Week.allCases, (-8)...(-2)) {
                if let intervalDate = current.date(byAdding: .day, value: interval, to: weekend), let day = current.dateComponents([.day], from: intervalDate).day {
                    week[weekday] = day
                }
            }
        }
        
        weekday = week
    }
    
    func checkDatabaseStatus() {
        let provider = MoyaProvider<API>()
        
        provider.request(.checkStatus) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodedData = try? JSONDecoder().decode(QueryDatabase.self, from: response.data) {
                        let status = decodedData.results.compactMap { queryProperties in
                            let unwrappedValue = queryProperties.properties.reduce(into: [String: String]()) {
                                let key = $1.key
                                
                                if let subject = $1.value.title, !subject.isEmpty {
                                    let text = subject.map { plainText in
                                        plainText.plain_text
                                    }
                                    
                                    $0[key] = text.first!
                                }
                                if let rich_text = $1.value.rich_text, !rich_text.isEmpty {
                                    let text = rich_text.map { plainText in
                                        plainText.plain_text
                                    }
                                    
                                    $0[key] = text.first!
                                }
                                if let title = $1.value.rich_text, !title.isEmpty {
                                    let text = title.map { plainText in
                                        plainText.plain_text
                                    }
                                    
                                    $0[key] = text.first!
                                }
                            }
                            
                            return unwrappedValue
                        }
                        
                        status.forEach {
                            if $0["Status"] == "Done" {
                                if let DB = $0["DB"], let queryType = QueryType(rawValue: DB) {
                                    self.requestDatabase(queryType)
                                }
                            }
                            else {
                                if let DB = $0["DB"], let queryType = QueryType(rawValue: DB) {
                                    self.requestDatabase(queryType, true)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func requestDatabase(_ queryType: QueryType, _ backup: Bool? = nil) {
        let provider = MoyaProvider<API>()
        
        switch queryType {
        case .restaurant:
            provider.request(.query(.restaurant)) { result in
                switch result {
                case .success(let response):
                    if (200..<300).contains(response.statusCode) {
                        if let decodedData = try? JSONDecoder().decode(QueryDatabase.self, from: response.data) {
                            self.newRestaurant = decodedData.results.compactMap { queryProperties in
                                let unwrappedValue = queryProperties.properties.reduce(into: [String: String]()) {
                                    let key = $1.key
                                    
                                    if let rich_text = $1.value.rich_text, !rich_text.isEmpty {
                                        let text = rich_text.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                    if let title = $1.value.rich_text, !title.isEmpty {
                                        let text = title.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                }
                                
                                return NewRestaurantResponse(unwrappedValue: unwrappedValue)
                            }
                        }
                    }
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        case .domitory:
            provider.request(.query(.domitory)) { result in
                switch result {
                case .success(let response):
                    if (200..<300).contains(response.statusCode) {
                        if let decodedData = try? JSONDecoder().decode(QueryDatabase.self, from: response.data) {
                            self.domitory = decodedData.results.compactMap { queryProperties in
                                let unwrappedValue = queryProperties.properties.reduce(into: [String: String]()) {
                                    let key = $1.key
                                    
                                    if let rich_text = $1.value.rich_text, !rich_text.isEmpty {
                                        let text = rich_text.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                    if let title = $1.value.rich_text, !title.isEmpty {
                                        let text = title.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                }
                                
                                return DomitoryResponse(unwrappedValue: unwrappedValue)
                            }
                        }
                    }
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func restaurantByBookmark() -> [Restaurant] {
        let bookmarkRestaurant = bookmark.map {
            Restaurant(rawValue: $0)!
        }
        
        let campusRestaurant = Campus(rawValue: selectedCampus)!.restaurant.filter {
            !bookmarkRestaurant.contains($0)
        }
        
        return bookmarkRestaurant + campusRestaurant
    }
    
    func saveDefaultCampus() {
        UserDefaults.standard.setValue(defaultCampus, forKey: "defaultCampus")
    }
    
    func saveBookmark() {
        UserDefaults.standard.setValue(bookmark, forKey: "bookmark")
    }
    
    func loadDefaultCampus() {
        guard let defaultCampus = UserDefaults.standard.string(forKey: "defaultCampus") else {
            self.defaultCampus = "부산"
            selectedCampus = "부산"
//            requestCampusDatabase()
            return
        }
        self.defaultCampus = defaultCampus
        selectedCampus = defaultCampus
//        requestCampusDatabase()
    }
    
    func loadBookmark() {
        guard let bookmark = UserDefaults.standard.stringArray(forKey: "bookmark") else {
            self.bookmark = []
            return
        }
        self.bookmark = bookmark
    }
}
