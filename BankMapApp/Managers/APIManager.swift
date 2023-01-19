//
//  APIManager.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import Foundation
import Moya

enum APIManager {
    case getATMsCities
    case getDepartmentCities
    case getATMsDetails(city: String?)
    case getDepartmentDetails(city: String?)
}

extension APIManager: TargetType {
    var baseURL: URL {
        return URL(string: "https://belarusbank.by/api/")!
    }
    
    var path: String {
        switch self {
            case .getATMsCities, .getATMsDetails:
                return "atm"
            case .getDepartmentCities, .getDepartmentDetails:
                return "filials_info"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getATMsCities, .getDepartmentCities, .getATMsDetails, .getDepartmentDetails:
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
            case .getATMsCities, .getDepartmentCities:
                return nil
        } 
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .getATMsCities, .getDepartmentCities, .getATMsDetails, .getDepartmentDetails:
                return URLEncoding.queryString
        }
    }
}

