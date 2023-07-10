//
//  AddItemView.swift
//  ResellTrack
//
//  Created by Tien Bui on 22/6/2023.
//

import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var data: Items
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var boughtDate = Date.now
    @State private var boughtPrice: Double = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item name", text: $name)
                    TextField("Bought price", value: $boughtPrice, format: .number)
                    DatePicker("Bought date", selection: $boughtDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Save") {
                        data.addItem(name: name, boughtPrice: boughtPrice, boughtDate: boughtDate)
                        dismiss()
                    }
                    //TODO: validate input
                }
            }
            .navigationTitle("Add Item")
        }
    }
}

    struct AddItemView_Previews: PreviewProvider {
        static var previews: some View {
            AddItemView()
        }
    }
