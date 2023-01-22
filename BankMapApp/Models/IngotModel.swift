//
//  IngotModel.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import Foundation
import ObjectMapper

final class IngotModel: Mappable {
    
    var city: String = ""
    var cityType: String = ""
    var filialNumber: String = ""
    var goldTen: String = ""
    var goldTwenty: String = ""
    var goldFifty: String = ""
    var silverTen: String = ""
    var silverTwenty: String = ""
    var silverFifty: String = ""
    var platinumTen: String = ""
    var platinumTwenty: String = ""
    var platinumFifty: String = ""
   
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        city              <- map["name"]
        cityType          <- map["name_type"]
        filialNumber      <- map["filials_text"]
        goldTen           <- map["ZOL_10_out"]
        goldTwenty        <- map["ZOL_20_out"]
        goldFifty         <- map["ZOL_50_out"]
        silverTen         <- map["SIL_10_out"]
        silverTwenty      <- map["SIL_20_out"]
        silverFifty       <- map["SIL_50_out"]
        platinumTen       <- map["PL_10_out"]
        platinumTwenty    <- map["PL_20_out"]
        platinumFifty     <- map["PL_30_out"]
    }
}
