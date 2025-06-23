
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
    private typealias NTDeploymentResp = NotionResponse<DeploymentProperties>
    private let session: URLSession
    private let mapper = Mapper.shared
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func fetch(campus: Campus) async throws -> [CafeteriaMenu] {
        self.cancleAllRequest()
        
        async let restaurantMenus: [CafeteriaMenu] = {
            let dpReq: NotionAPI = .status(type: .restaurant)
            let dbResp: NTDeploymentResp = try await fetch(dpReq)
            let dbStat = try mapper.mapDeploymentResponse(response: dbResp.results)
            
            let restaurantReq: NotionAPI = .restaurant(campus: campus, isUpdating: dbStat.isUpdating)
            let restaurantResp: RestaurantResponse = try await fetch(restaurantReq)
            
            return try mapper.mapRestaurantResponse(response: restaurantResp.results)
        }()
        
        async let dormitoryMenus: [CafeteriaMenu] = {
            let dpReq: NotionAPI = .status(type: .dormitory)
            let dbResp: NTDeploymentResp = try await fetch(dpReq)
            let dbStat = try mapper.mapDeploymentResponse(response: dbResp.results)

            let dormitoryReq: NotionAPI = .dormitory(campus: campus, isUpdating: dbStat.isUpdating)
            let dormitoryResp: DormitoryResponse = try await fetch(dormitoryReq)
            
            return try mapper.mapDormitoryResponse(response: dormitoryResp.results)
        }()
        
        return try await restaurantMenus + dormitoryMenus
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
