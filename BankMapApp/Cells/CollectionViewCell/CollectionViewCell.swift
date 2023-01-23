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

        setupUI()
    }
    
    func set(title: String) {
        self.cellLabel.text = title
        if self.isSelected {
            backgroundColor = .systemYellow
            cellLabel.textColor = .systemGray
            layer.borderWidth = 2
        }
    }
    
    private func setupUI() {
        backgroundColor = .systemGray
        layer.borderWidth = 0
        layer.borderColor = UIColor.systemYellow.cgColor
        layer.cornerRadius = 10
        cellLabel.textColor = .systemYellow
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupUI()
    }

}
