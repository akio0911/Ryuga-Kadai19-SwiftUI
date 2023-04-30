//
//  ContentView.swift
//  Kadai19-SwiftUI
//
//  Created by Ryuga on 2023/04/26.
//

import SwiftUI

struct Fruit: Identifiable, Equatable, Codable {
    var id = UUID()
    var name: String
    var isChecked: Bool

    init(name: String, isChecked: Bool = false) {
        self.name = name
        self.isChecked = isChecked
    }
}


struct ContentView: View {
    @State private var fruits:[Fruit]
    init() {
        let defaultItems = [
            Fruit(name: "りんご", isChecked: false),
            Fruit(name: "みかん", isChecked: true),
            Fruit(name: "バナナ", isChecked: false),
            Fruit(name: "パイナップル", isChecked: true)
        ]
        let fruitItems = (try? UserDefaultsManager.shared.loadFruitItems()) ?? defaultItems
        self._fruits = State(initialValue: fruitItems)
    }
    @State private var editMode: AddItemView.Mode?

    var body: some View {
        NavigationView {
            List {
                ForEach(fruits) { fruit in
                    ZStack {
                        HStack{
                            Image(systemName: "checkmark")
                                .foregroundColor(fruit.isChecked ? Color.orange : Color.white)
                            Spacer().frame(width: 15)
                            Text(fruit.name)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = fruits.firstIndex(of: fruit) {
                                fruits[index].isChecked.toggle()
                                do {
                                    try UserDefaultsManager.shared.saveFruitItems(fruits)
                                } catch {
                                    print("Failed to save fruit items: \(error.localizedDescription)")
                                }
                            }
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "info.circle")
                                .foregroundColor(Color.blue)
                                .onTapGesture {
                                    if let index = fruits.firstIndex(of: fruit) {
                                        editMode = .update(
                                            fruit: fruits[index],
                                            didSave: { updatedFruit in
                                                if let index = fruits.firstIndex(of: fruit) {
                                                    fruits[index] = updatedFruit
                                                    do {
                                                        try UserDefaultsManager.shared.saveFruitItems(fruits)
                                                    } catch {
                                                        print("Failed to save fruit items: \(error.localizedDescription)")
                                                    }
                                                }
                                                editMode = nil
                                            },
                                            didCancel: {
                                                editMode = nil
                                            }
                                        )
                                    }
                                }
                        }
                    }
                }
                .onDelete { (offsets) in
                    self.fruits.remove(atOffsets: offsets)
                    do {
                        try UserDefaultsManager.shared.saveFruitItems(fruits)
                    } catch {
                        print("Failed to save fruit items: \(error.localizedDescription)")
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editMode = .create(
                            didSave: { newFruit in
                                fruits.append(newFruit)
                                do {
                                    try UserDefaultsManager.shared.saveFruitItems(fruits)
                                } catch {
                                    print("Failed to save fruit items: \(error.localizedDescription)")
                                }
                                editMode = nil
                            },
                            didCancel: {
                                editMode = nil
                            }
                        )
                    }) {
                        Image(systemName: "plus")
                    }
                    .fullScreenCover(item: $editMode) { mode in
                        AddItemView(mode: mode)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

