//
//  CurrencyExchangeProvider.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import Foundation
import Moya
import Moya_ObjectMapper

class CurrencyExchangeProvider {
    private let provider = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin()])
    
    func getATMs(currencyBlock: @escaping ([ATMModel]) -> Void, failure: (() -> Void)? = nil) {
        provider.request(.atms) { result in
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
    
    func getDepartments(currencyBlock: @escaping ([DepartmentModel]) -> Void, failure: (() -> Void)? = nil) {
        provider.request(.departments) { result in
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

