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
    static private var requestArray: [Cancellable] = []
    
    static func request<T: Codable>(_ target: API, _ responseType: T.Type, completion: @escaping (T) -> (Void)) {
        let request = provider.request(target) { result in
            switch result {
            case .success(let response) where (200..<300).contains(response.statusCode):
                guard let decodedData = try? JSONDecoder().decode(T.self, from: response.data)
                else { return }
                completion(decodedData)
            default:
                break
            }
        }
        
        requestArray.append(request)
    }
    
    static func cancleAllRequest() {
        requestArray.forEach { $0.cancel() }
    }
}
