//
//  And.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct And: ConditionOperator, CustomStringConvertible {
    public let and: [any ConditionOperator]
    
    public init(_ and: [any ConditionOperator]) {
        self.and = and
    }
    
    public var description: String {
        """
        {
            "and": \(and)
        }
        """
    }
}
