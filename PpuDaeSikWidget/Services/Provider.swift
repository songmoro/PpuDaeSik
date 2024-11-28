//
//  Provider.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 11/25/24.
//

import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(configuration: ConfigurationIntent(), date: Date(), name: "금정회관", category: "중식", meal: "탄탄면\n마카로니콘샐러드\n단무지")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        guard let cafeteria = getCafeteria(for: configuration),
              let category = getCategory(for: configuration)
        else { return }
        
        let currentDate = Date()
        let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        
        Task {
            let response = await fetch(cafeteria: cafeteria, category: category)

            guard !response.isEmpty else {
                let entry = SimpleEntry(configuration: configuration, date: currentDate, name: cafeteria.shortName, category: category, meal: "메뉴가 존재하지 않아요.")
                let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
                
                completion(timeline)
                
                return
            }
            
            let shortName = response[0].cafeteria.shortName
            let content = response[0].content
            
            let entry = SimpleEntry(configuration: configuration, date: currentDate, name: shortName, category: category, meal: content)
            let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
            
            completion(timeline)
        }
    }
    
    func getCafeteria(for configuration: ConfigurationIntent) -> Cafeteria? {
        switch configuration.RestaurantEnum {
        case .d001: .진리관
        case .d002: .웅비관
        case .d003: .자유관
        case .d004: .비마관
        case .d005: .행림관
        case .g001: .금정회관교직원식당
        case .g002: .금정회관학생식당
        case .h001: .학생회관학생식당
        case .m001: .학생회관밀양교직원식당
        case .m002: .학생회관밀양학생식당
        case .s001: .샛벌회관식당
        case .y001: .편의동2층양산식당
        case .unknown: nil
        }
    }
    
    func getCategory(for configuration: ConfigurationIntent) -> String? {
        let hour = Calendar.current.component(.hour, from: Date())
        
        return switch configuration.RestaurantEnum {
        case .d001, .d002, .d003, .d004, .d005:
            switch hour {
            case 20...23: "01"
            case 0...8: "02"
            case 9...13: "03"
            case 14...19: "04"
            default: nil
            }
        case .g002, .y001:
            switch hour {
            case 20...23: "B"
            case 0...8: "B"
            case 9...13: "L"
            case 14...19: "D"
            default: nil
            }
        case .g001, .h001, .s001, .m001, .m002:
            switch hour {
            case 0...14: "L"
            case 15...19: "D"
            case 20...23: "L"
            default: nil
            }
        case .unknown: nil
        }
    }
}

extension Provider {
    func fetch(cafeteria: Cafeteria, category: String) async -> [CafeteriaResponse] {
        let response = await requestBy(cafeteria: cafeteria, category: category)
        
        return response
    }
    
    func checkDeployment(for type: DeploymentType) async -> Bool {
        let response: NotionResponse<DeploymentProperties> = await fetch(NotionAPI.status(type: type))
        let deploymentStatus = Deployment(response: response.results.first!.properties)
        
        return deploymentStatus.isUpdating
    }
    
    func requestBy(cafeteria: Cafeteria, category: String) async -> [CafeteriaResponse] {
        let isUpdating: Bool
        let response: [CafeteriaResponse]
        
        switch cafeteria {
        case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당, .학생회관밀양학생식당, .학생회관밀양교직원식당, .편의동2층양산식당:
            isUpdating = await checkDeployment(for: .restaurant)
            
            let restaurantResponse: RestaurantResponse = await fetch(NotionAPI.restaurant(cafeteria: cafeteria, category: category, isUpdating: isUpdating))
            response = restaurantResponse.convertToCafeteria()
        case .진리관, .웅비관, .자유관, .비마관, .행림관:
            isUpdating = await checkDeployment(for: .dormitory)
            
            let dormitoryResponse: DormitoryResponse = await fetch(NotionAPI.dormitory(cafeteria: cafeteria, category: category, isUpdating: isUpdating))
            response = dormitoryResponse.convertToCafeteria()
        }
        
        return response
    }
}

extension Provider {
    func fetch<T>(_ api: NotionAPIAble) async -> T where T: Codable {
        let session = URLSession.shared
        let request = api.request()
        let decoder = JSONDecoder()
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "No error message"
                let errorCode = extractErrorCode(from: data)
                throw NotionAPIError.from(statusCode: httpResponse.statusCode, errorCode: errorCode, message: errorMessage)
            }
            
            return try! decoder.decode(T.self, from: data)
        }
        catch(let error) {
            if error is NotionAPIError {
                fatalError((error as! NotionAPIError).localizedDescription)
            }
            else {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func extractErrorCode(from data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let errorCode = json["code"] as? String else {
            return "unknown_error"
        }
        return errorCode
    }
}
