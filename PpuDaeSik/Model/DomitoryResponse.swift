//
//  DomitoryResponse.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI

struct DomitoryResponse: Codable, Serializable {
    internal init(uuid: UUID = UUID(), integratedRestaurant: IntegratedRestaurant, mealDate: String, mealKindGcd: String, codeNm: String, mealNm: String, category: Category) {
        self.uuid = uuid
        self.integratedRestaurant = integratedRestaurant
        self.mealDate = mealDate
        self.mealKindGcd = mealKindGcd
        self.codeNm = codeNm
        self.mealNm = mealNm
        self.category = category
    }
    
    init(_ unwrappedValue: [String: String]) {
        self.mealDate = unwrappedValue["mealDate"] ?? ""
        self.mealKindGcd = unwrappedValue["mealKindGcd"] ?? ""
        self.codeNm = unwrappedValue["codeNm"] ?? ""
        self.mealNm = unwrappedValue["mealNm"] ?? ""
        
        let no = unwrappedValue["no"] ?? ""
        guard let integratedRestaurant = IntegratedRestaurant(code: no) else {
            fatalError("식당 분류 실패")
        }
        self.integratedRestaurant = integratedRestaurant
        self.category = switch self.mealKindGcd {
        case "01": .조기
        case "02": .조식
        case "03": .중식
        case "04": .석식
        default: .조기
        }
    }
    
    init?(_ properties: Properties) {
        let properties = properties.toDict()
        
        guard let no = properties["no"],
              let mealDate = properties["mealDate"],
              let mealKindGcd = properties["mealKindGcd"],
              let codeNm = properties["codeNm"],
              let mealNm = properties["mealNm"],
              let integratedRestaurant = IntegratedRestaurant(code: no)
        else { fatalError("기숙사 초기화 실패") }
        
        self.init(integratedRestaurant: integratedRestaurant, mealDate: mealDate, mealKindGcd: mealKindGcd, codeNm: codeNm, mealNm: mealNm, category: Category.getCategory(mealKindGcd: mealKindGcd))
    }
    
    var uuid = UUID()
    let integratedRestaurant: IntegratedRestaurant
    let mealDate: String
    let mealKindGcd: String
    let codeNm: String
    let mealNm: String
    let category: Category
}
