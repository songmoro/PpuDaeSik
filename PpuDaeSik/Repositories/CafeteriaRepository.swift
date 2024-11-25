//
//  CafeteriaRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/22/24.
//

import SwiftUI

struct CafeteriaRepository: NotionRepository {
    let session: URLSession
    
    func fetch<T>(_ api: NotionAPIAble) async -> T where T: Codable {
        let request = api.request()
        let decoder = JSONDecoder()
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            
            return try! decoder.decode(T.self, from: data)
        }
        catch {
            
        }
        
        return try! decoder.decode(T.self, from: Data())
    }
}
