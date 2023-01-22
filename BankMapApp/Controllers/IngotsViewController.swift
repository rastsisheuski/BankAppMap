//
//  IngotsViewController.swift
//  BankMapApp
//
//  Created by Hleb Rastsisheuski on 19.01.23.
//

import UIKit

class IngotsViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    private var selectedIngotType: IngotsType = .gold
    private var ingotArray = [IngotModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
    }
    
    private func registerCell() {
        let nib = UINib(nibName: String(describing: IgotsTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: IgotsTableViewCell.self))
    }
    
    private func getData() {
        spinnerView.startAnimating()
        CurrencyExchangeProvider().getIngots { result in
            result.forEach { model in
                self.ingotArray.append(model)
                self.tableView.reloadData()
            }
            self.spinnerView.stopAnimating()
        } failure: { 
            print ("Error")
            self.spinnerView.stopAnimating()
        }
    }
        
        @IBAction func segmentControlDidChange(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
                case 0:
                    selectedIngotType = .gold
                case 1:
                    selectedIngotType = .silver
                case 2:
                    selectedIngotType = .platinum
                default:
                    return
            }
            tableView.reloadData()
        }
    }
    
extension IngotsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IgotsTableViewCell.self), for: indexPath)
        (cell as? IgotsTableViewCell)?.set(model: ingotArray[indexPath.row], type: selectedIngotType)
        return cell
    }
}
    
extension IngotsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
