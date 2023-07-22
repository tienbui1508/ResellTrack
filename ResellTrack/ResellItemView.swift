//
//  ResellItemView.swift
//  ResellTrack
//
//  Created by Tien Bui on 22/7/2023.
//

import SwiftUI

struct ResellItemView: View {
    @EnvironmentObject var data: Items
    @Environment(\.dismiss) var dismiss
    
    @State var item: Item
    
    @State private var reSoldPrice: Double?
    @State private var reSoldDate: Date = Date.now
    
    @FocusState private var inputIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    
                    TextField("Resold price *", value: $reSoldPrice, format: .currency(code: "AUD"))
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                    
                    DatePicker("Resold date", selection: $item.reSoldDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Save") {
                        data.resell(item, for: reSoldPrice ?? 0, on: reSoldDate)
                        dismiss()
                    }
                    .disabled(reSoldPrice == nil)
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
            }
            .navigationTitle("Resell \(item.name)")
            
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
        }
    }
}

struct ResellItemView_Previews: PreviewProvider {
    static var previews: some View {
        ResellItemView(item: Item.exampleItem)
    }
}
