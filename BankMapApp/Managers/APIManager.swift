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
    case getIgots
    
}

extension APIManager: TargetType {
    var baseURL: URL {
        return URL(string: "https://belarusbank.by/api")!
    }
    
    var path: String {
        switch self {
            case .getATMsDetails:
                return "/atm"
            case .getDepartmentDetails:
                return "/filials_info"
            case .getGems:
                return "/getgems"
            case .getIgots:
                return "/getinfodrall"
        }
    }
    
    var method: Moya.Method {
        return .get
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
            case .getGems, .getIgots:
                return nil
        } 
        return params
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}

