//
//  RichTextExpression.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct RichTextExpression: ConditionOperator, CustomStringConvertible {
    public let property: String
    public let rich_text: RichText
    
    public init(property: String, rich_text: String) {
        self.property = property
        self.rich_text = .init(equals: rich_text)
    }
    
    public struct RichText: Codable {
        public let equals: String
        
        public init(equals: String) {
            self.equals = equals
        }
    }
    
    public var description: String {
        """
        {
            "property": "\(property)",
            "rich_text": {
                "equals": "\(rich_text.equals)"
            }
        }
        """
    }
}
