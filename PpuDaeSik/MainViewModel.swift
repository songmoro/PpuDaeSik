//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI
import Moya

class MainViewModel: ObservableObject {
    @Published var menu: [Week: [Restaurant: Meal]] = [:]
    @Published var selectedCampus = ""
    @Published var selectedDay = ""
    @Published var isSheetShow = false
    @Published var weekday: [Week: Int] = [:]
    @Published var defaultCampus = "부산"
    @Published var bookmark: [String] = []
    
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
    
    func requestCampusDatabase() {
        guard let campus = Campus(rawValue: selectedCampus) else { return }
        
        _ = Week.allCases.map {
            menu[$0] = {
                Dictionary(uniqueKeysWithValues: zip(campus.restaurant, Array(repeating: Meal(), count: campus.restaurant.count)))
            }()
        }
        
        let provider = MoyaProvider<API>()
        
        provider.request(.queryDatabase(campus)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodedData = try? JSONDecoder().decode(QueryDatabase.self, from: response.data) {
                        _ = decodedData.results.map { queryProperties in
                            var restaurant: Restaurant?
                            var category: Category?
                            let menuByWeekday: [Week: String] = queryProperties.properties.reduce([:]) { partialResult, property in
                                switch property.key {
                                case "식당":
                                    restaurant = Restaurant(rawValue: property.value.select!["name"]!)
                                case "식사 분류":
                                    category = Category(rawValue: property.value.select!["name"]!)
                                case "일", "월", "화", "수", "목", "금", "토":
                                    var dict = partialResult
                                    let plainText = property.value.rich_text?.compactMap { plainText in
                                        plainText.plain_text
                                    }.joined()
                                    dict.updateValue(plainText ?? "", forKey: Week(rawValue: property.key)!)
                                    return dict
                                default:
                                    break
                                }
                                
                                return partialResult
                            }
                            
                            if let restaurant = restaurant, let category = category {
                                _ = menuByWeekday.map { dict in
                                    if self.menu[dict.key]![restaurant] == nil {
                                        self.menu[dict.key]!.updateValue(Meal(foodByCategory: [category: dict.value]), forKey: restaurant)
                                    }
                                    else {
                                        self.menu[dict.key]![restaurant]?.foodByCategory.updateValue(dict.value, forKey: category)
                                    }
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
    
    func restaurantByBookmark() -> [Restaurant] {
        var bookmarkRestaurant = bookmark.map {
            Restaurant(rawValue: $0)!
        }
        
        var campusRestaurant = Campus(rawValue: selectedCampus)!.restaurant.filter {
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
            requestCampusDatabase()
            return
        }
        self.defaultCampus = defaultCampus
        selectedCampus = defaultCampus
        requestCampusDatabase()
    }
    
    func loadBookmark() {
        guard let bookmark = UserDefaults.standard.stringArray(forKey: "bookmark") else {
            self.bookmark = []
            return
        }
        self.bookmark = bookmark
    }
}
