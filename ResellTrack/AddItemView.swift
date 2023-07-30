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
    @State private var description = ""
    @State private var boughtDate = Date.now
    @State private var boughtPrice: Double?
    
    @FocusState private var inputIsFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item name *", text: $name)
//                        .focused($inputIsFocused)
                    
                    TextField("Bought price *", value: $boughtPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                    
                    ZStack(alignment: .leading) {
                        if description.isEmpty {
                            Text("Description")
                                .opacity(0.25)
                        }
                        
                        TextEditor(text: $description)
//                            .focused($inputIsFocused)
                    }
                    
                    DatePicker("Bought date", selection: $boughtDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Save") {
                        data.addItem(name: name, purchasePrice: boughtPrice ?? 0, purchaseDate: boughtDate)
                        dismiss()
                    }
                    .disabled(name.isEmpty || boughtPrice == nil)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
            }
            .navigationTitle("Add Item")
            
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

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
