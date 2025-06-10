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

public struct WidgetRepositoryImpl: WidgetRepository {
    private let session: URLSession
    private let mapper = Mapper.shared
    public init(session: URLSession) {
        self.session = session
    }
    
    public func fetch(cafeteria: Cafeteria, category: String) async -> CafeteriaMenu? {
        self.cancleAllRequest()
        
        let deploymentResponse: NotionResponse<DeploymentProperties>
        
        switch cafeteria {
        case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당, .학생회관밀양학생식당, .학생회관밀양교직원식당, .편의동2층양산식당:
            deploymentResponse = await fetch(WidgetNotionAPI.status(type: .restaurant))
            let deploymentStatus = mapper.mapDeploymentResponse(response: deploymentResponse.results)
            guard let deploymentStatus = deploymentStatus else { return nil }
            
            let restaurantResponses: RestaurantResponse = await fetch(
                WidgetNotionAPI.restaurant(
                    cafeteria: cafeteria,
                    category: category,
                    isUpdating: deploymentStatus.isUpdating
                )
            )
            let menus = mapper.mapRestaurantResponse(response: restaurantResponses.results)
            let menu = menus.first
            
            return menu
        case .진리관, .웅비관, .자유관, .비마관, .행림관:
            deploymentResponse = await fetch(WidgetNotionAPI.status(type: .dormitory))
            let deploymentStatus = mapper.mapDeploymentResponse(response: deploymentResponse.results)
            guard let deploymentStatus = deploymentStatus else { return nil }
            
            let dormitoryResponses: DormitoryResponse = await fetch(
                WidgetNotionAPI.dormitory(
                    cafeteria: cafeteria,
                    category: category,
                    isUpdating: deploymentStatus.isUpdating
                )
            )
            let menus = mapper.mapDormitoryResponse(response: dormitoryResponses.results)
            let menu = menus.first
            
            return menu
        }
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
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch {
                print("Decoding Error \(T.self) 디코딩 실패")
                print("에러: \(error)")
                print("원본 JSON:")
                print(String(data: data, encoding: .utf8) ?? "디코딩 불가능한 데이터")
                throw error
            }
        }
        catch let error as NotionAPIError {
            fatalError(error.localizedDescription)
        }
        catch {
            print("기타 네트워크 에러: \(error.localizedDescription)")
            fatalError(error.localizedDescription)
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
