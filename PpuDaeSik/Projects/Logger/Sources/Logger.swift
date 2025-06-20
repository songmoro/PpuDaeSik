//
//  Logger.swift
//  Logger
//
//  Created by 송재훈 on 6/20/25.
//

import Foundation

public struct Logger {
    public static let shared = Logger()
    
    private let session: URLSession
    private init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 5
        config.waitsForConnectivity = false
        config.networkServiceType = .background
        
        session = URLSession(configuration: config)
    }
    
    public func send(
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        error: Error,
        log: String = ""
    ) {
        let request = LogRequest(file: file, function: function, line: line, error: error, log: log).makeRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Notion 로깅 실패:", error)
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                print("Notion 응답 에러:", response.statusCode)
                if let data = data {
                    print(String(data: data, encoding: .utf8) ?? "encoding 실패")
                }
                return
            }
        }.resume()
    }
}
