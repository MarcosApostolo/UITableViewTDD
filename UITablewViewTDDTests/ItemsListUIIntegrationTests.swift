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
        
        XCTAssertEqual(loader.loadMessages.count, 1, "Expected load to be called once")
    }
    
    func test_onLoadError_displayErrorMessage() {
        let loader = LoaderSpy()
        let sut = ItemsListViewController()
        
        sut.loader = loader
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.errorMessageLabel.isHidden, "Expect error message not to be displayed when view loads")
        
        loader.completeWithError()
        
        XCTAssertFalse(sut.errorMessageLabel.isHidden, "Expect error message to be displayed when load fails")
    }
}

class LoaderSpy: ItemsLoader {
    var loadMessages = [(Result<[Item], Error>) -> Void]()
    
    func load(completion: @escaping (Result<[Item], Error>) -> Void) {
        loadMessages.append(completion)
    }
    
    func completeWithError(at index: Int = 0) {
        loadMessages[index](.failure(anyNSError()))
    }
}

func anyNSError() -> Error {
    NSError(domain: "any error", code: 0)
}

extension XCTestCase {
    func checkForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
