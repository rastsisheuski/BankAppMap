//
//  GemModel.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import Foundation
import ObjectMapper

final class GemModel: Mappable {
    var attestat: String = ""
    var shape: String = ""
    var grani: String = ""
    var weight: String = ""
    var color: String = ""
    var cost: String = ""
    var city: String = ""
    var filialId: String = ""
    
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        attestat        <- map["attestat"]
        shape           <- map["name_ru"]
        grani           <- map["grani"]
        weight          <- map["weight"]
        color           <- map["color"]
        cost            <- map["cost"]
        city            <- map["name"]
        filialId        <- map["filial_id"]
    }
}
