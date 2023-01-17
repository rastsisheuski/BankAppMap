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
    
    func getCurrencyExchange(city: String, currencyBlock: @escaping ([CurrencyExchangeModel]) -> Void, failure: (() -> Void)? = nil) {
        provider.request(.getCurrencyExchange(city: city)) { result in
            switch result {
                case .success(let responce):
                    guard let currencyExchange = try? responce.mapArray(CurrencyExchangeModel.self) else {
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

