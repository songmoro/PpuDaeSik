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
                                    self.requestByCampusDatabase(queryType, Campus(rawValue: self.selectedCampus)!)
                                }
                            }
                            else {
                                if let DB = $0["DB"], let queryType = QueryType(rawValue: DB) {
                                    self.requestByCampusDatabase(queryType, Campus(rawValue: self.selectedCampus)!, true)
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
    
    func requestByCampusDatabase(_ queryType: QueryType, _ campus: Campus, _ backup: Bool? = nil) {
        let provider = MoyaProvider<API>()

        switch queryType {
        case .restaurant:
            provider.request(.queryByCampus(.restaurant, campus, backup)) { result in
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
            provider.request(.queryByCampus(.domitory, campus, backup)) { result in
                switch result {
                case .success(let response):
                    if (200..<300).contains(response.statusCode) {
                        if let decodedData = try? JSONDecoder().decode(QueryDatabase.self, from: response.data) {
                            self.domitory = decodedData.results.compactMap { queryProperties in
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
    
    func sortedByBookmark() -> [String] {
        let restaurant = NewRestaurant.allCases.filter {
            !bookmark.contains($0.rawValue) && ($0.campus().rawValue == selectedCampus)
        }.sorted {
            ($0.order()) < ($1.order())
        }.map({ $0.rawValue })
        
        let domitory = Domitory.allCases.filter {
            !bookmark.contains($0.name()) && ($0.campus().rawValue == selectedCampus)
        }.sorted {
            ($0.order()) < ($1.order())
        }.map({ $0.name() })
        return bookmark + restaurant + domitory
    }
    
    func filterByRestaurant(_ restaurant: String) -> [NewRestaurantResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = week[selectedWeekday]?.day {
            return newRestaurant.filter {
                ($0.RESTAURANT.rawValue == restaurant) && (Int($0.MENU_DATE.suffix(2)) == day)
            }.sorted {
                $0.CATEGORY.order() < $1.CATEGORY.order()
            }
        }
        
        return []
    }
    
    func filterByDomitory(_ restaurant: String) -> [DomitoryResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = week[selectedWeekday]?.day {
            return domitory.filter {
                ($0.domitory.name() == restaurant) && (Int($0.mealDate.suffix(2)) == day)
            }
        }
        
        return []
    }
    
    func checkType(_ restaurant: String) -> QueryType {
        if (NewRestaurant.allCases.map({ $0.rawValue }).contains(restaurant)) {
            .restaurant
        }
        else {
            .domitory
        }
    }
    
    func filterByCategory(_ category: Category, _ restaurant: [NewRestaurantResponse]) -> [NewRestaurantResponse] {
        restaurant.filter {
            $0.CATEGORY == category
        }
    }
    
    func sortedRestaurant() -> [NewRestaurantResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = weekday[selectedWeekday] {
            let bookmarkRestaurant = newRestaurant.filter { restaurant in
                (bookmark.contains(restaurant.NAME)) && (restaurant.CAMPUS.rawValue == selectedCampus) && (Int(restaurant.MENU_DATE.suffix(2)) == day)
            }.sorted {
                ($0.RESTAURANT.order(), $0.CATEGORY.order()) < ($1.RESTAURANT.order(), $1.CATEGORY.order())
            }
            
            let restaurant = newRestaurant.filter {
                (!bookmark.contains($0.NAME)) && ($0.CAMPUS.rawValue == selectedCampus) && (Int($0.MENU_DATE.suffix(2)) == day)
            }.sorted {
                ($0.RESTAURANT.order(), $0.CATEGORY.order()) < ($1.RESTAURANT.order(), $1.CATEGORY.order())
            }
            
            return (bookmarkRestaurant + restaurant)
        }
        
        return []
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
