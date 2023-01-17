//
//  APIManager.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import Foundation
import Moya

enum APIManager {
    case getCurrencyExchange(city: String)
}

extension APIManager: TargetType {
    var baseURL: URL {
        return URL(string: "https://belarusbank.by/")!
    }
    
    var path: String {
        switch self {
            case .getCurrencyExchange:
                return "api/atm"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getCurrencyExchange:
                return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Moya.Task {
        guard let parametres else {
            return .requestPlain
        }
        return .requestParameters(parameters: parametres, encoding: encoding)
    }
    
    var parametres: [String: Any]? {
        var params = [String: Any]()
        
        switch self {
            case .getCurrencyExchange(let city):
                params["city"] = city
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .getCurrencyExchange:
                return URLEncoding.queryString
        }
    }
}

