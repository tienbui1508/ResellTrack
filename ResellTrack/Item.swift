//
//  Item.swift
//  ResellTrack
//
//  Created by Tien Bui on 10/7/2023.
//

import SwiftUI

class Item: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous Item"
    var boughtPrice = 0.0
    var reSoldPrice = 0.0
    var boughtDate = Date.now
    var reSoldDate = Date.now
    var description = "Description..."
    var resellGain: Double {
        reSoldPrice - boughtPrice
    }
    
    fileprivate(set) var isResold = false
    
    static let exampleItem = Item()
}

@MainActor class Items: ObservableObject {
    @Published private(set) var items: [Item]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            items = []
        }
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func addItem(name: String, boughtPrice: Double, boughtDate: Date) {
        let newItem = Item()
        newItem.id = UUID()
        newItem.name = name
        newItem.boughtPrice = boughtPrice
        newItem.boughtDate = boughtDate
        items.append(newItem)
        save()
    }
    
    func delete(_ item: Item) {
        items.removeAll { $0.id == item.id }
        save()
    }
    
    func resell(_ item: Item, for resoldPrice: Double, on resoldDate: Date) {
        objectWillChange.send()
        item.isResold = true
        item.reSoldPrice = resoldPrice
        item.reSoldDate = resoldDate
        save()
    }
    
    func undoResell(_ item: Item) {
        objectWillChange.send()
        item.isResold = false
        item.reSoldPrice = 0
        save()
    }
    
}
