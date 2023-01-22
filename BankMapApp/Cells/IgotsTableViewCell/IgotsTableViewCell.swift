//
//  IgotsTableViewCell.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 22.01.23.
//

import UIKit

class IgotsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var filialLabel: UILabel!
    @IBOutlet weak var typeOfMetalLabel: UILabel!
    @IBOutlet weak var tenLabel: UILabel!
    @IBOutlet weak var twentyLabel: UILabel!
    @IBOutlet weak var fiftyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(model: IngotModel, type: IngotsType) {
        filialLabel.text = "\(model.city), отделение №\(model.filialNumber)"
        var tenPrice = ""
        var twentyPrice = ""
        var fiftyPrice = ""
        
        switch type {
            case .gold:
                tenPrice = model.goldTen
                twentyPrice = model.goldTwenty
                fiftyPrice = model.goldFifty
            case .silver:
                tenPrice = model.silverTen
                twentyPrice = model.silverTwenty
                fiftyPrice = model.silverFifty
            case .platinum:
                tenPrice = model.platinumTen
                twentyPrice = model.platinumTwenty
                fiftyPrice = model.platinumFifty
        }
        typeOfMetalLabel.text = type.rawValue
        tenLabel.text = "Price for 10g ingot: \(tenPrice)"
        twentyLabel.text = "Price for 20g ingot: \(twentyPrice)"
        fiftyLabel.text = "Price for 50g ingot: \(fiftyPrice)"
    }

    
}
