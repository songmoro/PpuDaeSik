import Entities
import DTOs

//public struct Mapper {
//    public static let shared = Mapper()
//    private init() { }
//    
//    public func mapDormitoryResponse(response: [Result<DomitoryProperties>]) -> [CafeteriaMenu] {
//        response.compactMap {
//            convert(properties: $0.properties)
//        }
//    }
//    
//    private func convert(properties: DomitoryProperties) -> CafeteriaMenu? {
//        let code = properties.no.title[0].plainText
//        let cafeteria = Cafeteria(code)
//        let date = properties.mealDate.richText[0].plainText
//        let rawCategory = properties.mealKindGcd.richText[0].plainText
//        let category = Category(rawCategory)
//        let content = properties.mealNm.richText[0].plainText
//        
//        guard let cafeteria = cafeteria, let category = category else { return nil }
//        return CafeteriaMenu(cafeteria: cafeteria, date: date, category: category, content: content)
//    }
//    
//    public func mapRestaurantResponse(response: [Result<RestaurantProperties>]) -> [CafeteriaMenu] {
//        response.compactMap {
//            convert(properties: $0.properties)
//        }
//    }
//    
//    private func convert(properties: RestaurantProperties) -> CafeteriaMenu? {
//        let code = properties.restaurantCode.richText[0].plainText
//        let cafeteria = Cafeteria(code)
//        let title = properties.menuTitle.richText[0].plainText
//        let date = properties.menuDate.richText[0].plainText
//        let rawCategory = properties.menuType.richText[0].plainText
//        let category = Category(rawCategory)
//        let content = properties.menuContent.richText[0].plainText
//        let breakfastTime = properties.breakfastTime?.richText[0].plainText
//        let lunchTime = properties.lunchTime?.richText[0].plainText
//        let dinnerTime = properties.dinnerTime?.richText[0].plainText
//        
//        guard let cafeteria = cafeteria, let category = category else { return nil }
//        let time: String = switch category {
//        case .조기: ""
//        case .조식: breakfastTime ?? ""
//        case .중식: lunchTime ?? ""
//        case .석식: dinnerTime ?? ""
//        }
//        
//        return CafeteriaMenu(cafeteria: cafeteria, date: date, category: category, title: title, content: content, time: time)
//    }
//    
//    public func mapDeploymentResponse(response: [Result<DeploymentProperties>]) -> Deployment? {
//        guard let properties = response.first else { return nil }
//        return convert(properties: properties.properties)
//    }
//    
//    private func convert(properties: DeploymentProperties) -> Deployment {
//        return Deployment(
//            database: properties.DB.title[0].plainText == "restaurant" ? .restaurant : .dormitory,
//            isUpdating: properties.Status.richText[0].plainText != "Done"
//        )
//    }
//}

public struct Mapper {
    public static let shared = Mapper()
    private init() { }

    public func mapDormitoryResponse(response: [Result<DomitoryProperties>]) throws -> [CafeteriaMenu] {
        try response.map {
            try convert(properties: $0.properties)
        }
    }

    private func convert(properties: DomitoryProperties) throws -> CafeteriaMenu {
        guard
            let cafeteria = Cafeteria(properties.no.title.first?.plainText ?? ""),
            let category = Category(properties.mealKindGcd.richText.first?.plainText ?? "")
        else {
            throw NotionAPIError.validationError(description: "기숙사 식당 식단 매핑 실패")
        }

        return CafeteriaMenu(
            cafeteria: cafeteria,
            date: properties.mealDate.richText.first?.plainText ?? "",
            category: category,
            content: properties.mealNm.richText.first?.plainText ?? ""
        )
    }

    public func mapRestaurantResponse(response: [Result<RestaurantProperties>]) throws -> [CafeteriaMenu] {
        try response.map {
            try convert(properties: $0.properties)
        }
    }

    private func convert(properties: RestaurantProperties) throws -> CafeteriaMenu {
        guard
            let cafeteria = Cafeteria(properties.restaurantCode.richText.first?.plainText ?? ""),
            let category = Category(properties.menuType.richText.first?.plainText ?? "")
        else {
            throw NotionAPIError.validationError(description: "학생 식단 매핑 실패")
        }

        let time: String = switch category {
        case .조기: ""
        case .조식: properties.breakfastTime?.richText.first?.plainText ?? ""
        case .중식: properties.lunchTime?.richText.first?.plainText ?? ""
        case .석식: properties.dinnerTime?.richText.first?.plainText ?? ""
        }

        return CafeteriaMenu(
            cafeteria: cafeteria,
            date: properties.menuDate.richText.first?.plainText ?? "",
            category: category,
            title: properties.menuTitle.richText.first?.plainText ?? "",
            content: properties.menuContent.richText.first?.plainText ?? "",
            time: time
        )
    }

    public func mapDeploymentResponse(response: [Result<DeploymentProperties>]) throws -> Deployment {
        guard let properties = response.first?.properties else {
            throw NotionAPIError.validationError(description: "배포 상태 매핑 실패")
        }

        return Deployment(
            database: properties.DB.title.first?.plainText == "restaurant" ? .restaurant : .dormitory,
            isUpdating: properties.Status.richText.first?.plainText != "Done"
        )
    }
}
