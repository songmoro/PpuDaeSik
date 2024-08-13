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
    
    func queryDatabase(_ isUpdate: Bool, _ code: String, _ type: QueryType, category: [String], completion: @escaping ([String]) -> ()) {
        let provider = MoyaProvider<WidgetAPI>()
        
        provider.request(.queryByRestaurant(isUpdate: isUpdate, code: code, type: type, category: category)) { result in
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
                                
                                return RestaurantResponse(unwrappedValue)
                            }
                            
                            if let restrant = restrant.first {
                                completion([restrant.integratedRestaurant.shortName, restrant.category.rawValue, restrant.content])
                            }
                            else {
                                completion(["", "", "식단이 존재하지 않아요"])
                            }
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

                                return DomitoryResponse(unwrappedValue)
                            }
                            
                            if let domitory = domitory.first {
                                completion([domitory.integratedRestaurant.name, domitory.category.rawValue, domitory.mealNm])
                            }
                            else {
                                completion(["", "", "식단이 존재하지 않아요"])
                            }
                        }
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
