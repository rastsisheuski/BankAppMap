//
//  GemsCellTitle.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import Foundation

enum GemsCellTitle {
    case attestat
    case shape
    case grani
    case weight
    case color
    case cost
    case city
    case filialId
    
    var title: String {
        switch self {
            case .attestat:
                return "Номер аттестата:"
            case .shape:
                return "Форма огранки:"
            case .grani:
                return "Количество граней:"
            case .weight:
                return "Вес:"
            case .color:
                return "Цвет:"
            case .cost:
                return "Цена:"
            case .city:
                return "Город:"
            case .filialId:
                return "Номер отделения:"
        }
    }
}
