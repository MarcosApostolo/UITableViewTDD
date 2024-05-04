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
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadMessages.count, 1, "Expected load to be called once")
    }
    
    func test_onLoadError_displayErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.errorMessageLabel.isHidden, "Expect error message not to be displayed when view loads")
        
        loader.completeWithError()
        
        XCTAssertFalse(sut.errorMessageLabel.isHidden, "Expect error message to be displayed when load fails")
    }
    
    func test_onLoadSuccess_displayItems() {
        let (sut, loader) = makeSUT()
        
        let item0 = Item(name: "a name")
        let item1 = Item(name: "another name")
        let item2 = Item(name: "a different name")
        let allItems = [item0, item1, item2]
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, isRendering: [])
        
        loader.completeSuccessfully(with: allItems)
        
        assertThat(sut, isRendering: allItems)
    }
    
    // MARK Helpers
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ItemsListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = ItemsListUIComposer.makeItemsList(loader: loader)
        
        checkForMemoryLeaks(sut, file: file, line: line)
        checkForMemoryLeaks(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    func assertThat(_ sut: ItemsListViewController, isRendering items: [Item], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedItemCellViews, items.count, "Expected items displayed when load completes successfully")
        
        items.enumerated().forEach({ index, item in
            let view = sut.itemCell(for: index)

            guard let itemCell = view as? ItemCell else {
                return XCTFail("Expected \(ItemCell.self) instance, got \(String(describing: view)) instead")
            }
            
            XCTAssertEqual(itemCell.name, item.name)
        })
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
    
    func completeSuccessfully(with items: [Item], at index: Int = 0) {
        loadMessages[index](.success(items))
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

extension ItemsListViewController {
    var numberOfRenderedItemCellViews: Int {
        tableView.numberOfRows(inSection: section)
    }
    
    var section: Int {
        0
    }
    
    func itemCell(for index: Int) -> UITableViewCell {
        return tableView(tableView, cellForRowAt: IndexPath(row: index, section: section))
    }
}
