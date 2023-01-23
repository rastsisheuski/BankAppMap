//
//  GemsTableViewCell.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import UIKit

class GemsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attestatNumber: UILabel!
    @IBOutlet weak var formOfGrani: UILabel!
    @IBOutlet weak var numberOfGrani: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var numberOfFilials: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet var GemLabels: [UILabel]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    func set(model: GemModel) {
        self.attestatNumber.text =  "\(GemsCellTitle.attestat.title)  \(model.attestat)"
        self.formOfGrani.text = "\(GemsCellTitle.shape.title) \(model.shape)"
        self.numberOfGrani.text = "\(GemsCellTitle.grani.title) \(model.grani)"
        self.weight.text = "\(GemsCellTitle.weight.title) \(model.weight)"
        self.color.text = "\(GemsCellTitle.color.title) \(model.color)"
        self.city.text = "\(GemsCellTitle.city.title) \(model.city)"
        self.numberOfFilials.text = "\(GemsCellTitle.filialId.title) \(model.filialId)"
        self.cost.text = "\(GemsCellTitle.cost.title) \(model.cost)"
    }
    
    private func setupUI() {
        setupLabels()
    }
    
    private func setupLabels() {
        GemLabels.forEach { label in
            label.textColor = .systemGray
            label.font = UIFont.systemFont(ofSize: 13)
            label.adjustsFontSizeToFitWidth = true
        }
    }
}
