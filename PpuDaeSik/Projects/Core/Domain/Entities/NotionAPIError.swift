//
//  NotionAPIError.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/24/24.
//

enum NotionAPIError: Error {
    case invalidJSON(description: String)
    case invalidRequestURL(description: String)
    case invalidRequest(description: String)
    case invalidGrant(description: String)
    case validationError(description: String)
    case missingVersion(description: String)
    case unauthorized(description: String)
    case restrictedResource(description: String)
    case objectNotFound(description: String)
    case conflictError(description: String)
    case rateLimited(description: String)
    case internalServerError(description: String)
    case badGateway(description: String)
    case serviceUnavailable(description: String)
    case databaseConnectionUnavailable(description: String)
    case gatewayTimeout(description: String)

    var localizedDescription: String {
        return switch self {
        case .invalidJSON(let description): "Invalid JSON: \(description)"
        case .invalidRequestURL(let description): "Invalid Request URL: \(description)"
        case .invalidRequest(let description): "Invalid Request: \(description)"
        case .invalidGrant(let description): "Invalid Grant: \(description)"
        case .validationError(let description): "Validation Error: \(description)"
        case .missingVersion(let description): "Missing Version: \(description)"
        case .unauthorized(let description): "Unauthorized: \(description)"
        case .restrictedResource(let description): "Restricted Resource: \(description)"
        case .objectNotFound(let description): "Object Not Found: \(description)"
        case .conflictError(let description): "Conflict Error: \(description)"
        case .rateLimited(let description): "Rate Limited: \(description)"
        case .internalServerError(let description): "Internal Server Error: \(description)"
        case .badGateway(let description): "Bad Gateway: \(description)"
        case .serviceUnavailable(let description): "Service Unavailable: \(description)"
        case .databaseConnectionUnavailable(let description): "Database Connection Unavailable: \(description)"
        case .gatewayTimeout(let description): "Gateway Timeout: \(description)"
        }
    }
}

extension NotionAPIError {
    static func from(statusCode: Int, errorCode: String, message: String) -> NotionAPIError {
        return switch (statusCode, errorCode) {
        case (400, "invalid_json"): .invalidJSON(description: message)
        case (400, "invalid_request_url"): .invalidRequestURL(description: message)
        case (400, "invalid_request"): .invalidRequest(description: message)
        case (400, "invalid_grant"): .invalidGrant(description: message)
        case (400, "validation_error"): .validationError(description: message)
        case (400, "missing_version"): .missingVersion(description: message)
        case (401, "unauthorized"): .unauthorized(description: message)
        case (403, "restricted_resource"): .restrictedResource(description: message)
        case (404, "object_not_found"): .objectNotFound(description: message)
        case (409, "conflict_error"): .conflictError(description: message)
        case (429, "rate_limited"): .rateLimited(description: message)
        case (500, "internal_server_error"): .internalServerError(description: message)
        case (502, "bad_gateway"): .badGateway(description: message)
        case (503, "service_unavailable"): .serviceUnavailable(description: message)
        case (503, "database_connection_unavailable"): .databaseConnectionUnavailable(description: message)
        case (504, "gateway_timeout"): .gatewayTimeout(description: message)
        default: .internalServerError(description: "Unknown error occurred.")
        }
    }
}
