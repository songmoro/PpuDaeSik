//
//  Or.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct Or: ConditionOperator, CustomStringConvertible {
    let or: [any ConditionOperator]
    
    init(_ or: [any ConditionOperator]) {
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
