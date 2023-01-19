//
//  GemsViewController.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import UIKit

class GemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var gems = [GemModel]()

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
            self.gems = gemsData
            self.tableView.reloadData()
        } failure: {
            print("Error")
        }
    }
}

extension GemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GemsTableViewCell.self), for: indexPath)
        (cell as? GemsTableViewCell)?.set(model: gems[indexPath.row])
        return cell
    }
    
    
}

extension GemsViewController: UITableViewDelegate {
    
}
