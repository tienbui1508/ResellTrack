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
    @State private var isShowingUndoAlert = false
    
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
                                
                                HStack {
                                    Text("Purchase: $\(String(format: "%.0f", item.purchasePrice)) on \(item.purchaseDate.formatted(date: .numeric, time: .omitted))")
                                }
                                .font(.caption)
                                
                                if item.isResold == true {
                                    HStack {
                                        Text("Resell: $\(String(format: "%.0f", item.resellPrice)) on \(item.resellDate.formatted(date: .numeric, time: .omitted))")
                                    }
                                    .font(.caption)
                                }
                            }
                            
                            if item.isResold {
                                Spacer()
                                VStack {
                                    Image(systemName: "dollarsign.arrow.circlepath")
                                    Text("$\(String(format: "%.0f", item.resellGain))")
                                    
                                }
                                .foregroundColor(item.resellGain > 0 ? .green : (item.resellGain < 0 ? .red : .yellow))
                            }
                        }
                        .swipeActions {
                            if item.isResold {
                                Button {
                                    reSoldItem = item
                                    isShowingUndoAlert = true
                                } label: {
                                    Label("Mark Available", systemImage: "arrow.uturn.backward.circle")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    reSoldItem = item
                                    isShowingResellItemScreen = true
                                } label: {
                                    Label("Mark Resold", systemImage: "dollarsign.arrow.circlepath")
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
                ToolbarItem {
                    Button {
                        isShowingSortOptions = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
                
                ToolbarItem {
                    Button {
                        isShowingAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .sheet(isPresented: $isShowingAddScreen) {
                AddItemView()
            }
            .sheet(isPresented: $isShowingResellItemScreen) {
                ResellItemView(item: reSoldItem)
            }
            .alert("Are you sure?", isPresented: $isShowingUndoAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Mark available") {
                    data.undoResell(reSoldItem)
                }
            } message: {
                Text("This action will undo the resale. Purchase information will be kept.")
            }
            .confirmationDialog("Sort by…", isPresented: $isShowingSortOptions) {
                Button("Default (Date added)") { sortOrder = .default }
                Button("Name (A-Z)") { sortOrder = .name }
                Button("Date bought (Newest first)") { sortOrder = .date }
            }
            .searchable(text: $searchText, prompt: "Find items")
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
            return filteredItems.sorted { $0.purchaseDate > $1.purchaseDate }
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
