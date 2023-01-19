//
//  CurrencyExchangeProvider.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import Foundation
import Moya
import Moya_ObjectMapper

final class CurrencyExchangeProvider {
    private let provider = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin()])
    
    func getATMs(city: String? = nil, currencyBlock: @escaping ([ATMModel]) -> Void, failure: (() -> Void)? = nil) {
        provider.request(.getATMsDetails(city: city)) { result in
            switch result {
                case .success(let responce):
                    guard let currencyExchange = try? responce.mapArray(ATMModel.self) else {
                        failure?()
                        return
                    }
                    currencyBlock(currencyExchange)
                case .failure(let error):
                    print(error.localizedDescription)
                    failure?()
            }
        }
    }
    
    func getDepartments(city: String? = nil, currencyBlock: @escaping ([DepartmentModel]) -> Void, failure: (() -> Void)? = nil) {
        provider.request(.getDepartmentDetails(city: city)) { result in
            switch result {
                case .success(let responce):
                    guard let currencyExchange = try? responce.mapArray(DepartmentModel.self) else {
                        failure?()
                        return
                    }
                    currencyBlock(currencyExchange)
                case .failure(let error):
                    print(error.localizedDescription)
                    failure?()
            }
        }
    }
}

