//
//  RequestManager.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI
import Moya

class RequestManager {
    static private let provider = MoyaProvider<API>()
    
    static func request(_ target: API, completion: @escaping ([[String: String]]) -> ()) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodedData = try? JSONDecoder().decode(NotionResponse<DeploymentProperties>.self, from: response.data) {
                        let status = decodedData.results.compactMap {
                            $0.properties.toDict()
                        }
                        
                        completion(status)
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static func request<T: Serializable>(_ target: API, _ responseType: T.Type, completion: @escaping ([T]) -> (Void)) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodedData = try? JSONDecoder().decode(NotionResponse<DomitoryProperties>.self, from: response.data) {
                        let mappedValue = decodedData.results.compactMap {
                            T($0.properties)
                        }
                        
                        completion(mappedValue)
                    }
                    
                    if let decodedData = try? JSONDecoder().decode(NotionResponse<RestaurantProperties>.self, from: response.data) {
                        let mappedValue = decodedData.results.compactMap {
                            T($0.properties)
                        }
                        
                        completion(mappedValue)
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
