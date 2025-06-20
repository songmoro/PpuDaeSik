import Entities
import DTOs

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
