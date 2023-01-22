//
//  GemsViewController.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import UIKit

class GemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    
    private var gemsArray = [GemModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        registerCell()
        getData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerCell() {
        let nib = UINib(nibName: String(describing: GemsTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: GemsTableViewCell.self))
    }
    
    private func getData() {
        CurrencyExchangeProvider().getGems { [weak self] gemsData in
            guard let self else { return }
            self.gemsArray = gemsData
            self.sortedToHeighest()
            self.tableView.reloadData()
        } failure: {
            print("Error")
        }
    }
    
    private func sortedToHeighest() {
        gemsArray.sort { $0.cost > $1.cost }
        filterButton.setTitle("Sorted to heighest", for: .normal)
    }
    
    private func sortedToLowest() {
        gemsArray.sort { $0.cost < $1.cost }
        filterButton.setTitle("Sorted to lowest", for: .selected)
    }
    
    @IBAction func filterButtonDidTap(_ sender: UIButton) {
        switch sender.isSelected {
            case true:
                sortedToHeighest()
            case false:
                sortedToLowest()
        }
        sender.isSelected.toggle()
        tableView.reloadData()
    }
}

extension GemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GemsTableViewCell.self), for: indexPath)
        (cell as? GemsTableViewCell)?.set(model: gemsArray[indexPath.row])
        return cell
    }
}

extension GemsViewController: UITableViewDelegate {
    
}
