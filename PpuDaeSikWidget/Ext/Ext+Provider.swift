//
//  Ext+Provider.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 5/3/24.
//

import SwiftUI
import Moya

extension Provider {
    func checkStatus(completion: @escaping (DeploymentStatus) -> ()) {
        let provider = MoyaProvider<WidgetAPI>()
        
        provider.request(.checkStatus) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodedData = try? JSONDecoder().decode(NotionResponse<DeploymentProperties> .self, from: response.data) {
                        let status = decodedData.results.compactMap {
                            $0.properties.toDict()
                        }
                        
                        status.forEach {
                            guard let DB = $0["DB"],
                                  let status = $0["Status"],
                                  let deploymentStatus = DeploymentStatus(status: status)
                            else { return }
                            
                            completion(deploymentStatus)
                        }
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func queryDatabase(_ cafeteria: Cafeteria, category: String, _ deploymentStatus: DeploymentStatus, completion: @escaping ([String]) -> ()) {
        let provider = MoyaProvider<WidgetAPI>()
        
        provider.request(.query(cafeteria: cafeteria, category, deploymentStatus)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    switch cafeteria {
                    case .금정회관교직원식당, .금정회관학생식당, .샛벌회관식당, .학생회관학생식당, .학생회관밀양학생식당, .학생회관밀양교직원식당, .편의동2층양산식당:
                        guard let decodedData = try? JSONDecoder().decode(NotionResponse<RestaurantProperties>.self, from: response.data),
                              let first = decodedData.results.compactMap({ IntegratedResponse($0.properties) }).first
                        else {
                            completion(["", "", "식단이 존재하지 않아요"])
                            return
                        }
                        
                        completion([first.cafeteria.shortName, first.category.rawValue, first.content])
                    case .진리관, .웅비관, .자유관, .비마관, .행림관:
                        guard let decodedData = try? JSONDecoder().decode(NotionResponse<DomitoryProperties>.self, from: response.data),
                              let first = decodedData.results.compactMap({ IntegratedResponse($0.properties) }).first
                        else {
                            completion(["", "", "식단이 존재하지 않아요"])
                            return
                        }
                        
                        completion([first.cafeteria.shortName, first.category.rawValue, first.content])
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
