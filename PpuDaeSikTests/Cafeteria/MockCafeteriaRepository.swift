//
//  MockCafeteriaRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 6/1/25.
//

@testable import PpuDaeSik
import XCTest

struct MockCafeteriaRepository: CafeteriaRepositoryProtocol {
    var session: URLSession
    var mockResponse: Any
    
    init(session: URLSession, mockResponse: Any) {
        self.session = session
        self.mockResponse = mockResponse
    }
    
    func fetch<T>(_ api: NotionAPIAble) async -> T where T : Decodable, T : Encodable {
        return mockResponse as! T
    }
    
    func cancleAllRequest() {
        
    }
}
