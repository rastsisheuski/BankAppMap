//
//  APIManager.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import Foundation
import Moya

enum APIManager {
    case atms
    case departments
}

extension APIManager: TargetType {
    var baseURL: URL {
        return URL(string: "https://belarusbank.by/api/")!
    }
    
    var path: String {
        switch self {
            case .atms:
                return "atm"
            case .departments:
                return "filials_info"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .atms:
                return .get
            case .departments:
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
        switch self {
            case .atms:
                return .requestPlain
            case .departments:
                return .requestPlain
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .atms:
                return URLEncoding.queryString
            case .departments:
                return URLEncoding.queryString
        }
    }
}

