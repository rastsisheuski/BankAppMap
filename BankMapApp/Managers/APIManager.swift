//
//  APIManager.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import Foundation
import Moya

enum APIManager {
    case getATMsDetails(city: String?)
    case getDepartmentDetails(city: String?)
    case getGems
}

extension APIManager: TargetType {
    var baseURL: URL {
        switch self {
            case .getATMsDetails, .getDepartmentDetails:
                return URL(string: "https://belarusbank.by/api/")!
            case .getGems:
                return URL(string: "https://belarusbank.by/api/")!
        }
    }
    
    var path: String {
        switch self {
            case .getATMsDetails:
                return "atm"
            case .getDepartmentDetails:
                return "filials_info"
            case .getGems:
                return "getgems"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case  .getATMsDetails, .getDepartmentDetails, .getGems:
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
        guard let parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
    
    var parameters: [String : Any]? {
        var params = [String: Any]()
        switch self {
            case .getATMsDetails(let city):
                params["city"] = city
            case .getDepartmentDetails(let city):
                params["city"] = city
            case .getGems:
                return nil
        } 
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .getATMsDetails, .getDepartmentDetails, .getGems:
                return URLEncoding.queryString
        }
    }
}

