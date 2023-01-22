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
                let (tenValid, twentyValid, fiftyValid) = validatePrices(ten: model.goldTen, twenty: model.goldTwenty, fifty: model.goldFifty)
                tenPrice = tenValid
                twentyPrice = twentyValid
                fiftyPrice = fiftyValid
            case .silver:
                let (tenValid, twentyValid, fiftyValid) = validatePrices(ten: model.silverTen, twenty: model.silverTwenty, fifty: model.silverFifty)
                tenPrice = tenValid
                twentyPrice = twentyValid
                fiftyPrice = fiftyValid
            case .platinum:
                let (tenValid, twentyValid, fiftyValid) = validatePrices(ten: model.platinumTen, twenty: model.platinumTwenty, fifty: model.platinumFifty)
                tenPrice = tenValid
                twentyPrice = twentyValid
                fiftyPrice = fiftyValid
        }
        typeOfMetalLabel.text = type.rawValue
        
        tenLabel.text = "Price for 10g ingot: \(tenPrice)"
        twentyLabel.text = "Price for 20g ingot: \(twentyPrice)"
        fiftyLabel.text = "Price for 50g ingot: \(fiftyPrice)"
    }
    
    private func validatePrices(ten: String, twenty: String, fifty: String) -> (String, String, String) {
        var tenReturn = ten
        var twentyReturn = twenty
        var fiftyReturn = fifty
        
        if ten.isEmpty || ten == "0.00" {
            tenReturn = "Нет в наличии"
        }
        
        if twenty.isEmpty || twenty == "0.00" {
            twentyReturn = "Нет в наличии"
        }
        
        if fifty.isEmpty || fifty == "0.00" {
            fiftyReturn = "Нет в наличии"
        }
        
        return (tenReturn, twentyReturn, fiftyReturn)
    }
}
