//
//  ItemsListViewController.swift
//  UITablewViewTDD
//
//  Created by Marcos Amaral on 04/05/24.
//

import UIKit

public final class ItemsListViewController: UITableViewController {
    public var viewModel: ItemsListViewModel? {
        didSet { bind() }
    }
    
    var tableModel = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private(set) public lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        
        label.text = viewModel?.errorMessage
        
        label.isHidden = true
        
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: String(describing: ItemCell.self))
        
        viewModel?.loadItems()
    }
    
    func bind() {
        viewModel?.onErrorStateChange = { [weak self] _ in
            self?.errorMessageLabel.isHidden = false
        }
        viewModel?.onItemsLoad = { [weak self] items in
            self?.tableModel = items
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: ItemCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ItemCell
        
        let model = tableModel[indexPath.row]
        
        cell.name = model.name
        
        return cell
    }
}
