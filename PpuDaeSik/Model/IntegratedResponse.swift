//
//  IntegratedResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/14/24.
//

import Foundation

/// 기숙사, 학생 식당 응답
struct IntegratedResponse: Serializable {
    internal init(restaurant: IntegratedRestaurant, date: String, category: Category, title: String? = nil, content: String) {
        self.restaurant = restaurant
        self.date = date
        self.category = category
        self.title = title
        self.content = content
    }
    
    init(_ unwrappedValue: [String : String]) {
        self.init(restaurant: IntegratedRestaurant.금정회관교직원식당, date: "", category: .조기, content: "")
    }
    
    /// 옵셔널 초기화
    init?(_ properties: Properties) {
        let properties = properties.toDict()
        let title = properties["title"]
        
        guard let code = properties["code"],
              let integratedRestaurant = IntegratedRestaurant(code: code),
              let date = properties["date"],
              let rawCategory = properties["category"],
              let category = Category(rawValue: rawCategory),
              let content = properties["content"]
        else { return nil }
        
        self.init(restaurant: integratedRestaurant, date: date, category: category, title: title, content: content)
    }
    
    var uuid = UUID()
    /// 기숙사, 학생 식당 기본 정보
    let restaurant: IntegratedRestaurant
    /// 식단 날짜
    let date: String
    /// 식단 타입(조기, 조식, 중식, 석식)
    /// 기숙사: 조기, 조식, 중식, 석식
    /// 학생 식당: 조식, 중식, 석식
    let category: Category
    /// 학생 식당 식단 명
    let title: String?
    /// 식단
    let content: String
}
