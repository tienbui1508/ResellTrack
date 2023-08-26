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
    
    @State private var reSellPrice: Double?
    @State private var resellDate: Date = Date.now
    
    @FocusState private var inputIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    
                    TextField("Resold price *", value: $reSellPrice, format: .currency(code: "AUD"))
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                    
                    DatePicker("Resold date", selection: $resellDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Save") {
                        data.resell(item, for: reSellPrice ?? 0, on: resellDate)
                        dismiss()
                    }
                    .disabled(reSellPrice == nil)
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
