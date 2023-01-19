//
//  CurrencyExchangeModel.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

protocol Cityable {
    var cityName: String? { get }
}


import Foundation
import ObjectMapper

final class ATMModel: Mappable, Cityable {
    var cityName: String?
    var gpsX: String = ""
    var gpsY: String = ""
    var city: String = ""
    var cityType: String = ""
    var adressType: String = ""
    var adress : String = ""
    var house: String = ""
    var cashIn: String = ""
    var id: String = ""
    
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        gpsX            <- map["gps_x"]
        gpsY            <- map["gps_y"]
        city            <- map["city"]
        cityType        <- map["city_type"]
        adressType      <- map["address_type"]
        adress          <- map["address"]
        house           <- map["house"]
        cashIn          <- map["cash_in"]
        id              <- map["id"]
        cityName        <- map["city"]
    }
}
