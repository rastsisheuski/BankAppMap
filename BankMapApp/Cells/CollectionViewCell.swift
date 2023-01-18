//
//  CollectionViewCell.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 17.01.23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        setupUI()
    }
    
    func set(title: String) {
        self.cellLabel.text = title
    }
    
    private func setupUI() {
        setupLabels()
    }
    
    private func setupLabels() {
        cellLabel.font = .systemFont(ofSize: 18, weight: .bold)
        cellLabel.textColor = .black
        cellLabel.textAlignment = .center
        cellLabel.adjustsFontSizeToFitWidth = true
    }

}
