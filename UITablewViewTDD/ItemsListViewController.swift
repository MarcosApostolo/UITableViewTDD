//
//  ItemsListViewController.swift
//  UITablewViewTDD
//
//  Created by Marcos Amaral on 04/05/24.
//

import UIKit

public struct Item {
    let name: String
}

public protocol ItemsLoader {
    func load(completion: @escaping (Result<[Item], Error>) -> Void)
}

public final class ItemsListViewController: UITableViewController {
    public var loader: ItemsLoader?
    
    private(set) public lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "There was an error when trying to load items"
        
        label.isHidden = true
        
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load(completion: { [weak self] result in
            switch result {
            case .failure:
                self?.errorMessageLabel.isHidden = false
            default:
                break
            }
        })
    }
}
