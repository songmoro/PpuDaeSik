//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI
import Moya

class MainViewModel: ObservableObject {
    @Published var menu: [Week: [String: Meal]] = [:]
    
    func requestCampusDatabase(_ campus: Campus) {
        _ = Week.allCases.map {
            menu[$0] = [:]
        }
        
        let provider = MoyaProvider<API>()
        
        provider.request(.queryDatabase(campus)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodedData = try? JSONDecoder().decode(QueryDatabase.self, from: response.data) {
                        _ = decodedData.results.map { queryProperties in
                            var restaurant: String?
                            var category: Category?
                            let menuByWeekday: [Week: String] = queryProperties.properties.reduce([:]) { partialResult, property in
                                switch property.key {
                                case "식당":
                                    restaurant = property.value.select!["name"]
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
}

enum Category: String, CaseIterable, Hashable {
    case 조식, 중식, 석식
}

struct Meal: Hashable {
    var foodByCategory: [Category: String] = [:]
}

struct QueryDatabase: Codable {
    var results: [QueryProperties]
    
    struct QueryProperties: Codable {
        var properties: [String: QueryProperty]

        struct QueryProperty: Codable {
            var type: String
            var rich_text: [RichText]?
            var select: [String: String]?
            
            struct RichText: Codable {
                var plain_text: String
            }
        }
    }
}
