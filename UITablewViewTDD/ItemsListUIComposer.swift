//
//  ItemsListUIComposer.swift
//  UITablewViewTDD
//
//  Created by Marcos Amaral on 04/05/24.
//

import Foundation

public class ItemsListUIComposer {
    private init() {}
    
    public static func makeItemsList(loader: ItemsLoader) -> ItemsListViewController {
        let vc = ItemsListViewController()
        let viewModel = ItemsListViewModel(loader: DispatchOnMainQueueDecorator(decoratee: loader))
        
        vc.viewModel = viewModel
        
        return vc
    }
}

class DispatchOnMainQueueDecorator: ItemsLoader {
    private let decoratee: ItemsLoader
    
    init(decoratee: ItemsLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (Result<[Item], Error>) -> Void) {
        decoratee.load { result in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
