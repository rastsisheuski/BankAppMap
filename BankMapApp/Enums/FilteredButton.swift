//
//  FilteredButton.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import Foundation

enum FilteredButton: CaseIterable {
    case selectAll
    case atm
    case department
    
    var description: String {
        switch self {
            case .selectAll:
                return "Все"
            case .atm:
                return "Банкоматы"
            case .department:
                return "Отделения"
        }
    }
}
