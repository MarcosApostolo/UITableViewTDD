//
//  ItemsLoader.swift
//  UITablewViewTDD
//
//  Created by Marcos Amaral on 04/05/24.
//

import Foundation

public protocol ItemsLoader {
    func load(completion: @escaping (Result<[Item], Error>) -> Void)
}
