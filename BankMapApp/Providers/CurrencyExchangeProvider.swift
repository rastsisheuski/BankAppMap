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
                case .success(let response):
                    guard let currencyExchange = try? response.mapArray(ATMModel.self) else {
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
                case .success(let response):
                    guard let currencyExchange = try? response.mapArray(DepartmentModel.self) else {
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
    
    func getGems(currencyBlock: @escaping ([GemModel]) -> Void, failure: (() -> Void)? = nil) {
        provider.request(.getGems) { result in
            switch result {
                case .success(let response):
                    guard let gem = try? response.mapArray(GemModel.self) else {
                        failure?()
                        return
                    }
                    currencyBlock(gem)
                case .failure(let error):
                    print(error.localizedDescription)
                    failure?()
            }
        }
    }
    
    func getIngots(succes: @escaping ([IngotModel]) -> Void, failure: (() -> Void)? = nil) {
        provider.request(.getIgots) { result in
            switch result {
                case .success(let response):
                    guard let ingots = try? response.mapArray(IngotModel.self) else {
                        failure?()
                        return
                    }
                    succes(ingots)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

