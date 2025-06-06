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
    private let session: URLSession = URLSession.shared
    private let mapper = Mapper.shared
    public init() {}
    
    public func fetch(campus: Campus) async -> [CafeteriaMenu] {
        self.cancleAllRequest()
             
        let (restaurantDeploymentResponse, dormitoryDeploymentResponse): (NotionResponse<DeploymentProperties>, NotionResponse<DeploymentProperties>) = await (
            fetch(NotionAPI.status(type: .restaurant)),
            fetch(NotionAPI.status(type: .dormitory))
        )
        let (restaurantDeploymentStatus, dormitoryDeploymentStatus) = (
            mapper.mapDeploymentResponse(response: restaurantDeploymentResponse.results),
            mapper.mapDeploymentResponse(response: dormitoryDeploymentResponse.results)
        )
        
        guard let restaurantDeploymentStatus = restaurantDeploymentStatus,
              let dormitoryDeploymentStatus = dormitoryDeploymentStatus else {
            return []
        }
        
        let (restaurantResponses, dormitoryResponses): (RestaurantResponse, DormitoryResponse) = await (
            fetch(NotionAPI.restaurant(campus: campus, isUpdating: restaurantDeploymentStatus.isUpdating)),
            fetch(NotionAPI.restaurant(campus: campus, isUpdating: dormitoryDeploymentStatus.isUpdating))
        )
        let cafeteriaMenus: [CafeteriaMenu] = mapper.mapRestaurantResponse(response: restaurantResponses.results) + mapper.mapDormitoryResponse(response: dormitoryResponses.results)
        
        return cafeteriaMenus
    }
    
    private func fetch<T>(_ api: NotionAPIAble) async -> T where T: Codable {
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
