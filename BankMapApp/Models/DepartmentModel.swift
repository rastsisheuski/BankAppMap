//
//  DepartmentModel.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import ObjectMapper

final class DepartmentModel: Mappable, Cityable {
    var cityName: String?
    var cityType: String?
    var gpsX: String = ""
    var gpsY: String = ""
    var filialName: String = ""
    var nameType: String = ""
    var city: String = ""
    
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        gpsX            <- map["GPS_X"]
        gpsY            <- map["GPS_Y"]
        nameType        <- map["name_type"]
        filialName      <- map["filial_name"]
        city            <- map["name"]
        cityName        <- map["name"]
        cityType        <- map["name_type"]
    }
}

