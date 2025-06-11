//
//  MultiFilter.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct MultiFilter: CustomStringConvertible {
    public let filter: [any ConditionOperator]
    
    public init(filter: [any ConditionOperator]) {
        self.filter = filter
    }
    
    public var description: String {
        """
        {
            "filter": [ \(filter.map { $0.description + ",\n" }) ]
        }
        """
    }
}
