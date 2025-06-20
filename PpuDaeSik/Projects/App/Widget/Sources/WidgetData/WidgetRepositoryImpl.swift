//
//  WidgetRepositoryImpl.swift
//  App
//
//  Created by 송재훈 on 6/11/25.
//

import Foundation
import Entities
import DTOs
import Mappers
import Logger

public struct WidgetRepositoryImpl: WidgetRepository {
    private let session: URLSession
    private let mapper = Mapper.shared
    public init(session: URLSession) {
        self.session = session
    }
    
    public func fetch(cafeteria: Cafeteria, category: String) async -> CafeteriaMenu? {
        self.cancleAllRequest()

        do {
            let deploymentResponse: NotionResponse<DeploymentProperties>

            switch cafeteria {
            case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당, .학생회관밀양학생식당, .학생회관밀양교직원식당, .편의동2층양산식당:
                deploymentResponse = try await fetch(WidgetNotionAPI.status(type: .restaurant))
                let deploymentStatus = try mapper.mapDeploymentResponse(response: deploymentResponse.results)

                let restaurantResponses: RestaurantResponse = try await fetch(
                    WidgetNotionAPI.restaurant(
                        cafeteria: cafeteria,
                        category: category,
                        isUpdating: deploymentStatus.isUpdating
                    )
                )

                let menus = try mapper.mapRestaurantResponse(response: restaurantResponses.results)
                return menus.first
            case .진리관, .웅비관, .자유관, .비마관, .행림관:
                deploymentResponse = try await fetch(WidgetNotionAPI.status(type: .dormitory))
                let deploymentStatus = try mapper.mapDeploymentResponse(response: deploymentResponse.results)

                let dormitoryResponses: DormitoryResponse = try await fetch(
                    WidgetNotionAPI.dormitory(
                        cafeteria: cafeteria,
                        category: category,
                        isUpdating: deploymentStatus.isUpdating
                    )
                )

                let menus = try mapper.mapDormitoryResponse(response: dormitoryResponses.results)
                return menus.first
            }

        } catch {
            Task {
                let log = "widget: [cafeteria: \(cafeteria) category: \(category) date: \(Date())]"
                Logger.shared.send(error: error, log: log)
            }
            return nil
        }
    }
    
    private func fetch<T>(_ api: NotionAPIAble) async throws -> T where T: Codable {
        let request = api.request()
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NotionAPIError.serviceUnavailable(description: error.localizedDescription)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NotionAPIError.internalServerError(description: "Invalid response type")
        }

        guard httpResponse.statusCode == 200 else {
            let message = String(data: data, encoding: .utf8) ?? "No message"
            let errorCode = extractErrorCode(from: data)
            throw NotionAPIError.from(statusCode: httpResponse.statusCode, errorCode: errorCode, message: message)
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("Decoding Error: \(T.self)")
            print("Error: \(error)")
            print("Raw JSON: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw NotionAPIError.invalidJSON(description: "Decoding failed: \(error.localizedDescription)")
        }
    }
    
    private func extractErrorCode(from data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let errorCode = json["code"] as? String else {
            return "unknown error"
        }
        return errorCode
    }
    
    private func cancleAllRequest() {
        session.invalidateAndCancel()
    }
}
