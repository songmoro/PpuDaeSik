//
//  CafeteriaResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/14/24.
//

import Foundation

/// 기숙사, 학생 식당 응답
struct CafeteriaResponse: Hashable {
    internal init(cafeteria: Cafeteria, date: String, category: Category, title: String? = nil, content: String) {
        self.cafeteria = cafeteria
        self.date = date
        self.category = category
        self.title = title
        self.content = content
    }
    
    /// 옵셔널 초기화
    init?(from properties: [String: String]) {
        let title = properties["title"]
        
        guard let code = properties["code"],
              let cafeteria = Cafeteria(code),
              let date = properties["date"],
              let rawCategory = properties["category"],
              let category = Category(rawCategory),
              let content = properties["content"]
        else { return nil }
        
        self.init(cafeteria: cafeteria, date: date, category: category, title: title, content: content)
    }
    
    var uuid = UUID()
    /// 기숙사, 학생 식당 기본 정보
    let cafeteria: Cafeteria
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
