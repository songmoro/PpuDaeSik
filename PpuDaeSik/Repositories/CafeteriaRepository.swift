//
//  CafeteriaRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/22/24.
//

import SwiftUI

protocol CafeteriaRepositoryProtocol: NotionRepository {
    func fetch<T: Codable>(_ api: NotionAPIAble) async -> T
    func cancleAllRequest()
}

struct CafeteriaRepository: CafeteriaRepositoryProtocol {
    let session: URLSession
    
    func fetch<T>(_ api: NotionAPIAble) async -> T where T: Codable {
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
    
    func cancleAllRequest() {
        session.invalidateAndCancel()
    }
}
