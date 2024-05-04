//
//  Ext+Provider.swift
//  PpuDaeSikWidgetExtension
//
//  Created by 송재훈 on 5/3/24.
//

import SwiftUI
import Moya

extension Provider {
    func checkDatabase(completion: @escaping (Bool) -> ()) {
        let provider = MoyaProvider<WidgetAPI>()
        
        provider.request(.checkStatus) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    if let decodedData = try? JSONDecoder().decode(CheckDatabase.self, from: response.data) {
                        let status = decodedData.results.compactMap { queryProperties in
                            let unwrappedValue = queryProperties.properties.reduce(into: [String: String]()) {
                                let key = $1.key
                                
                                if let subject = $1.value.title, !subject.isEmpty {
                                    let text = subject.map { plainText in
                                        plainText.plain_text
                                    }
                                    
                                    $0[key] = text.first!
                                }
                                if let rich_text = $1.value.rich_text, !rich_text.isEmpty {
                                    let text = rich_text.map { plainText in
                                        plainText.plain_text
                                    }
                                    
                                    $0[key] = text.first!
                                }
                                if let title = $1.value.rich_text, !title.isEmpty {
                                    let text = title.map { plainText in
                                        plainText.plain_text
                                    }
                                    
                                    $0[key] = text.first!
                                }
                            }
                            
                            return unwrappedValue
                        }
                        
                        if status.contains(where: { $0["Status"] == "Done" }) {
                            completion(true)
                        }
                        else {
                            completion(false)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func queryDatabase(_ isUpdate: Bool, _ code: String, _ type: QueryType, completion: @escaping (String) -> ()) {
        let provider = MoyaProvider<WidgetAPI>()
        
        provider.request(.queryByRestaurant(isUpdate: isUpdate, code: code, type: type)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodedData = try? JSONDecoder().decode(QueryDatabase.self, from: response.data) {
                        switch type {
                        case .restaurant:
                            let restrant = decodedData.results.compactMap { queryProperties in
                                let unwrappedValue = queryProperties.properties.reduce(into: [String: String]()) {
                                    let key = $1.key
                                    
                                    if let rich_text = $1.value.rich_text, !rich_text.isEmpty {
                                        let text = rich_text.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                    if let title = $1.value.rich_text, !title.isEmpty {
                                        let text = title.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                }
                                
                                return RestaurantResponse(unwrappedValue: unwrappedValue)
                            }
                            
                            print(restrant)
                            completion(restrant.first?.MENU_CONTENT ?? "")
                        case .domitory:
                            let domitory = decodedData.results.compactMap { queryProperties in
                                let unwrappedValue = queryProperties.properties.reduce(into: [String: String]()) {
                                    let key = $1.key
                                    
                                    if let subject = $1.value.title, !subject.isEmpty {
                                        let text = subject.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                    if let rich_text = $1.value.rich_text, !rich_text.isEmpty {
                                        let text = rich_text.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                    if let title = $1.value.rich_text, !title.isEmpty {
                                        let text = title.map { plainText in
                                            plainText.plain_text
                                        }
                                        
                                        $0[key] = text.first!
                                    }
                                }

                                return DomitoryResponse(unwrappedValue: unwrappedValue)
                            }
                            
                            print(domitory)
                            completion(domitory.first?.mealNm ?? "")
                        }
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
