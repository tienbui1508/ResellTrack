//
//  ItemsView.swift
//  ResellTrack
//
//  Created by Tien Bui on 10/7/2023.
//

import SwiftUI

struct ItemsView: View {
    enum FilterType {
        case none, resold, available
    }
    
    enum SortType: String, CaseIterable {
        case `default`, name, date
    }
    
    @EnvironmentObject var data: Items
    
    @AppStorage("sortType") var sortOrder = SortType.default
    
    @State private var isShowingAddScreen = false
    @State private var isShowingSortOptions = false
    @State private var isShowingResellItemScreen = false
    
    @State private var searchText = ""
    @State private var reSoldItem: Item = Item()
    
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedItems) { item in
                    NavigationLink {
                        DetailsView(item: item)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("$\(String(format: "%.0f", item.boughtPrice))")
                                    .font(.caption)
                            }
                            
                            if item.isResold && filter == .none {
                                Spacer()
                                Image(systemName: "dollarsign.arrow.circlepath")
                                    .foregroundColor(item.resellGain >= 0 ? .green : .red)
                            }
                            
                            if item.isResold && filter == .resold {
                                Spacer()
                                Text("$\(String(format: "%.0f", item.resellGain))")
                                    .foregroundColor(item.resellGain >= 0 ? .green : .red)
                            }
                        }
                        .swipeActions {
                            if item.isResold {
                                Button {
                                    data.undoResell(item)
                                } label: {
                                    Label("Mark Resold", systemImage: "checkmark.circle")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    reSoldItem = item
                                    isShowingResellItemScreen = true
                                } label: {
                                    Label("Mark Available", systemImage: "dollarsign.arrow.circlepath")
                                }
                                .tint(.green)
                            }
                            
                            Button(role: .destructive)  {
                                data.delete(item)
                            } label: {
                                Label("Delete item", systemImage: "trash")
                            }
                        }
                    }
                    
                    
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingSortOptions = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                        if sortOrder == .name {
                            Label("sort by name", systemImage: "abc")
                        } else if sortOrder == .date {
                            Label("sort by name", systemImage: "calendar")
                        }
                        
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddScreen = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddScreen) {
                AddItemView()
            }
            .sheet(isPresented: $isShowingResellItemScreen) {
                ResellItemView(item: reSoldItem)
            }
            .confirmationDialog("Sort by…", isPresented: $isShowingSortOptions) {
                Button("Default (Date added)") { sortOrder = .default }
                Button("Name (A-Z)") { sortOrder = .name }
                Button("Date bought (Newest first)") { sortOrder = .date }
            }
            .searchable(text: $searchText, prompt: "Search for an item")
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "All Items"
        case .resold:
            return "Resold Items"
        case .available:
            return "Available Items"
        }
    }
    
    var filteredItems: [Item] {
        let result: [Item]
        switch filter {
        case .none:
            result = data.items
        case .resold:
            result = data.items.filter { $0.isResold }
        case .available:
            result = data.items.filter { !$0.isResold }
        }
        
        if searchText.isEmpty {
            return result
        } else {
            return result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var sortedItems: [Item] {
        switch sortOrder {
        case .name:
            return filteredItems.sorted { $0.name < $1.name }
        case .date:
            return filteredItems.sorted { $0.boughtDate > $1.boughtDate }
        default:
            return filteredItems.reversed()
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(filter: .none)
            .environmentObject(Items())
    }
}
