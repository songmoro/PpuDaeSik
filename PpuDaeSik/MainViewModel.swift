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
    @Published var week: [Week: DateComponents] = [:]
    @Published var defaultCampus = "부산"
    @Published var bookmark: [String] = []
    @Published var newRestaurant = [NewRestaurantResponse]()
    @Published var domitory = [DomitoryResponse]()
    
    func currentWeek() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            return calendar
        }()
        
        let interval: [Int] = switch calendar.component(.weekday, from: Date()) {
        case 1: [ 0,  1,  2,  3,  4,  5,  6]
        case 2: [-1,  0,  1,  2,  3,  4,  5]
        case 3: [-2, -1,  0,  1,  2,  3,  4]
        case 4: [-3, -2, -1,  0,  1,  2,  3]
        case 5: [-4, -3, -2, -1,  0,  1,  2]
        case 6: [-5, -4, -3, -2, -1,  0,  1]
        case 7: [-6, -5, -4, -3, -2, -1,  0]
        default: []
        }
        
        let week = interval.map {
            let date = calendar.date(byAdding: .day, value: $0, to: Date())

            return calendar.dateComponents([.year, .month, .day, .weekday], from: date!)
        }.compactMap({ $0 })
        
        
        self.week = Dictionary(uniqueKeysWithValues: zip(Week.allCases, week.sorted(by: { $0.weekday! < $1.weekday! })))
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
