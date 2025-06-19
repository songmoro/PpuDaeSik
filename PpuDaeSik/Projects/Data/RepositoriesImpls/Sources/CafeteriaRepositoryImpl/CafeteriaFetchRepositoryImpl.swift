
 //
//  CafeteriaFetchRepositoryImpl.swift
//  RepositoriesImpls
//
//  Created by 송재훈 on 6/6/25.
//

import Foundation
import Entities
import Repositories
import DTOs
import Mappers
import Shared

public struct CafeteriaFetchRepositoryImpl: CafeteriaFetchRepository {
    private let session: URLSession
    private let mapper = Mapper.shared
    public init(session: URLSession) {
        self.session = session
    }
    
    public func fetch(campus: Campus) async throws -> [CafeteriaMenu] {
        self.cancleAllRequest()

        let (restaurantDeploymentResponse, dormitoryDeploymentResponse): (NotionResponse<DeploymentProperties>, NotionResponse<DeploymentProperties>) = try await (
            fetch(NotionAPI.status(type: .restaurant)),
            fetch(NotionAPI.status(type: .dormitory))
        )

        let restaurantDeploymentStatus = try mapper.mapDeploymentResponse(response: restaurantDeploymentResponse.results)
        let dormitoryDeploymentStatus = try mapper.mapDeploymentResponse(response: dormitoryDeploymentResponse.results)

        let (restaurantResponses, dormitoryResponses): (RestaurantResponse, DormitoryResponse) = try await (
            fetch(NotionAPI.restaurant(campus: campus, isUpdating: restaurantDeploymentStatus.isUpdating)),
            fetch(NotionAPI.dormitory(campus: campus, isUpdating: dormitoryDeploymentStatus.isUpdating))
        )

        let restaurantMenus: [CafeteriaMenu] = try mapper.mapRestaurantResponse(response: restaurantResponses.results)
        let dormitoryMenus: [CafeteriaMenu] = try mapper.mapDormitoryResponse(response: dormitoryResponses.results)
        
        let cafeteriaMenus = restaurantMenus + dormitoryMenus
        return cafeteriaMenus
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
    
    private func cancleAllRequest() {
        session.invalidateAndCancel()
    }
    
    private func extractErrorCode(from data: Data) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let errorCode = json["code"] as? String else {
            return "unknown error"
        }
        return errorCode
    }
}
