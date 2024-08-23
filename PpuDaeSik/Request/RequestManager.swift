//
//  RequestManager.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 7/13/24.
//

import SwiftUI
import Moya

class RequestManager {
    static let shared = RequestManager()
    
    private let provider = MoyaProvider<API>()
    private var requestArray: [Cancellable] = []
    
    func request<T: Codable>(_ target: API, _ responseType: T.Type) async -> T {
        await withCheckedContinuation { continuation in
            self.request(target, responseType) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    private func request<T: Codable>(_ target: API, _ responseType: T.Type, completion: @escaping (T) -> (Void)) {
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
    
    func cancleAllRequest() {
        requestArray.forEach { $0.cancel() }
        requestArray.removeAll()
    }
}
