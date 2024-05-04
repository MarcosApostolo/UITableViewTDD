//
//  ItemsListViewModel.swift
//  UITablewViewTDD
//
//  Created by Marcos Amaral on 04/05/24.
//

import Foundation

public class ItemsListViewModel {
    private let loader: ItemsLoader
    
    typealias Observer<T> = (T) -> Void
    
    var onErrorStateChange: Observer<Void>?
    var onItemsLoad: Observer<[Item]>?
    
    public init(loader: ItemsLoader) {
        self.loader = loader
    }
    
    public let errorMessage = "There was an error when trying to load items"
    
    func loadItems() {
        loader.load(completion: { [weak self] result in
            switch result {
            case .failure:
                self?.onErrorStateChange?(())
            case let .success(items):
                self?.onItemsLoad?(items)
            }
        })
    }
}
