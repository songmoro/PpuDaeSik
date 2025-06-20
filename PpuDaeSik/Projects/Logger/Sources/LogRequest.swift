//
//  LogRequest.swift
//  Logger
//
//  Created by 송재훈 on 6/20/25.
//

import Foundation
import UIKit

fileprivate final class LoggerBundleClass {}

internal struct LogRequest {
    private let url = "https://api.notion.com/v1/pages"
    private let databaseId = "2187204caeef800f855ade107447e99c"
    private let method = "POST"
    private let headers: [String: String]
    private let deviceModel = UIDevice.current.model
    private let iosVersion = UIDevice.current.systemVersion
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    private let file: String
    private let function: String
    private let line: Int
    private let error: Error
    private let log: String
    
    internal init(file: String, function: String, line: Int, error: Error, log: String) {
        self.file = file
        self.function = function
        self.line = line
        self.error = error
        self.log = log
        let apiKey = Bundle(for: LoggerBundleClass.self).infoDictionary?["LOGGER_API_KEY"] as? String
        
        self.headers = [
            "Content-Type": "application/json",
            "Notion-Version": "2022-02-22",
            "Authorization": apiKey ?? ""
        ]
    }
    
    internal func makeRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = self.method
        request.allHTTPHeaderFields = self.headers
        request.httpBody = self.makeBody()
        
        return request
    }
    
    private func makeBody() -> Data? {
        let properties: [String: Any] = [
            "Device_Model": ["rich_text": [["text": ["content": deviceModel]]]],
            "iOS_Version": ["rich_text": [["text": ["content": iosVersion]]]],
            "App_Version": ["rich_text": [["text": ["content": appVersion]]]],
            "File": ["rich_text": [["text": ["content": file]]]],
            "Function": ["rich_text": [["text": ["content": function]]]],
            "Line": ["rich_text": [["text": ["content": line.description]]]],
            "Error": ["rich_text": [["text": ["content": error.localizedDescription]]]],
            "Log": ["rich_text": [["text": ["content": log]]]],
        ]
        
        let body: [String: Any] = [
            "parent": ["database_id": databaseId],
            "properties": properties
        ]
        
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}
