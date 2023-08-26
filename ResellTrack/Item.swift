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
    var purchasePrice = 0.0
    var resellPrice = 0.0
    var purchaseDate = Date.now
    var resellDate = Date.now
    var description = ""
    var resellGain: Double {
        resellPrice - purchasePrice
    }
    
    var isResold = false
    
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
        objectWillChange.send()
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Data saved")
        } catch {
            print("Unable to save data.")
        }
    }
    
    func addItem(name: String, purchasePrice: Double, purchaseDate: Date, description: String) {
        objectWillChange.send()
        let newItem = Item()
        newItem.id = UUID()
        newItem.name = name
        newItem.purchasePrice = purchasePrice
        newItem.purchaseDate = purchaseDate
        newItem.description = description
        items.append(newItem)
        save()
    }
    
    func delete(_ item: Item) {
        objectWillChange.send()
        items.removeAll { $0.id == item.id }
        save()
    }
    
    func resell(_ item: Item, for resellPrice: Double, on resellDate: Date) {
        objectWillChange.send()
        item.resellPrice = resellPrice
        item.resellDate = resellDate
        item.isResold = true
        save()
    }
    
    func undoResell(_ item: Item) {
        objectWillChange.send()
        item.isResold = false
        item.resellPrice = 0
        save()
    }
}
