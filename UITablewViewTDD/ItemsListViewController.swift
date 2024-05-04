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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load(completion: { _ in })
    }
}