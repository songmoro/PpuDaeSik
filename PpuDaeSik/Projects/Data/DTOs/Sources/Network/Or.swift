//
//  Or.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct Or: ConditionOperator, CustomStringConvertible {
    public let or: [any ConditionOperator]
    
    public init(_ or: [any ConditionOperator]) {
        self.or = or
    }
    
    public var description: String {
        """
        {
            "or": \(or)
        }
        """
    }
}
