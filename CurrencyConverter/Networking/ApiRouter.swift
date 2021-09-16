//
//  Network.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import Foundation
import Alamofire
import RxSwift

enum ApiRouter: URLRequestConvertible {
    
    case convertCurrency(amount: Double, fromCur: String, toCur: String)
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkConstants.BASEURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .convertCurrency:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .convertCurrency(let amount, let fromCur, let toCur):
            return "exchange/\(amount)-\(fromCur)/\(toCur)/latest"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .convertCurrency:
            return nil
        }
    }
}
