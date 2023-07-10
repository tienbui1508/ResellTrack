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
    
    enum SortType {
        case name, date
    }
    
    @EnvironmentObject var data: Items
    @State private var isShowingAddScreen = false
    
    @State private var sortOrder = SortType.date
    @State private var isShowingSortOptions = false
    
    let filter: FilterType
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredItems) { item in
                    NavigationLink {
                        DetailsView(item: item)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                            }
                            
                            if item.isResold && filter == .none {
                                Spacer()
                                Image(systemName: "circle.fill.badge.checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                        .swipeActions {
                            if item.isResold {
                                Button {
                                    data.toggle(item)
                                } label: {
                                    Label("Mark Resold", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    data.toggle(item)
                                } label: {
                                    Label("Mark Available", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)
                                
                              
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
            .confirmationDialog("Sort by…", isPresented: $isShowingSortOptions) {
                Button("Name (A-Z)") { sortOrder = .name }
                Button("Date (Newest first)") { sortOrder = .date }
            }
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

        if sortOrder == .name {
            return result.sorted { $0.name < $1.name }
        } else {
            //TODO: change to actual added date or date sold
            return result.reversed()
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(filter: .none)
            .environmentObject(Items())
    }
}
