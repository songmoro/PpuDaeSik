//
//  SingleFilter.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct SingleFilter: CustomStringConvertible {
    public let filter: any ConditionOperator
    
    public init(_ filter: any ConditionOperator) {
        self.filter = filter
    }
    
    public var description: String {
        """
        {
            "filter": \(filter)
        }
        """
    }
}
