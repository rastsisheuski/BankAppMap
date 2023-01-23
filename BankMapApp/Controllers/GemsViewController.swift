//
//  GemsViewController.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import UIKit

class GemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var gemsArray = [GemModel]()
    private var sortedButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()
        registerCell()
        getData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.title = "Gems"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: .bold) as Any]
        sortedButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .done, target: self, action: #selector(sortedButtonDidTap(sender:)))
        navigationItem.rightBarButtonItem = sortedButton
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
        sortedButton.title = "Sorted to heighest"
    }
    
    private func sortedToLowest() {
        gemsArray.sort { $0.cost < $1.cost }
        sortedButton.title = "Sorted to lowest"
        navigationItem.rightBarButtonItem?.title = "Sorted to lowest"
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

extension GemsViewController {
    @objc private func sortedButtonDidTap(sender: UIBarButtonItem) {
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
