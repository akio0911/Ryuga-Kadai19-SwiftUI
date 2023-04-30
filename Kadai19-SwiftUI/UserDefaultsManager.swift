//
//  UserDefaultsManager.swift
//  Kadai19-SwiftUI
//
//  Created by Ryuga on 2023/04/27.
//

import Foundation

class UserDefaultsManager {
    enum Error: Swift.Error {
        case saveError
        case loadError
    }

    static let shared = UserDefaultsManager()

    private let fruitsKey = "fruitItems"

    func saveFruitItems(_ items: [Fruit]) throws {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: fruitsKey)
        } catch {
            throw Error.saveError
        }
    }

    func loadFruitItems() throws -> [Fruit] {
        guard let data = UserDefaults.standard.data(forKey: fruitsKey) else {
            throw Error.loadError
        }
        do {
            return try JSONDecoder().decode([Fruit].self, from: data)
        } catch {
            throw Error.loadError
        }
    }
}

