//
//  FilteredButton.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import Foundation

enum FilteredButton: CaseIterable {
    case all
    case atm
    case department
    
    var description: String {
        switch self {
            case .all:
                return "Все"
            case .atm:
                return "Банкоматы"
            case .department:
                return "Отделения"
        }
    }
}
