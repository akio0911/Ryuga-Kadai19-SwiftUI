//
//  UserDefaultsManager.swift
//  Kadai19-SwiftUI
//
//  Created by Ryuga on 2023/04/27.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let fruitsKey = "fruitItems"

    func saveFruitItems(_ items: [Fruit]) {
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: fruitsKey)
        } catch {
            print("Failed to save fruit items: \(error.localizedDescription)")
        }
    }

    func loadFruitItems(defaultItems: [Fruit]) -> [Fruit] {
        guard let data = UserDefaults.standard.data(forKey: fruitsKey) else {
            return defaultItems
        }
        let items = try? JSONDecoder().decode([Fruit].self, from: data)
        return items ?? defaultItems
    }
}

