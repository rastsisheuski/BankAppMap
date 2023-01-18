//
//  DepartmentModel.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import ObjectMapper

final class DepartmentModel: Mappable {
    var gpsX: String = ""
    var gpsY: String = ""
    var filialName: String = ""
    var nameType: String = ""
    var cityName: String = ""
    
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        gpsX            <- map["GPS_X"]
        gpsY            <- map["GPS_Y"]
        nameType        <- map["name_type"]
        filialName      <- map["filial_name"]
        cityName        <- map["name"]
    }
}

