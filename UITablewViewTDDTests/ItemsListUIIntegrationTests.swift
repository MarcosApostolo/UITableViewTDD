//
//  UITablewViewTDDTests.swift
//  UITablewViewTDDTests
//
//  Created by Marcos Amaral on 04/05/24.
//

import XCTest
import UITablewViewTDD

final class ItemsListUIIntegrationTests: XCTestCase {
    func test_onLoad_loadItems() {
        let loader = LoaderSpy()
        let sut = ItemsListViewController()
        
        sut.loader = loader
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadMessages.count, 1)
    }
}

class LoaderSpy: ItemsLoader {
    var loadMessages = [(Result<[Item], Error>) -> Void]()
    
    func load(completion: @escaping (Result<[Item], Error>) -> Void) {
        loadMessages.append(completion)
    }
}
