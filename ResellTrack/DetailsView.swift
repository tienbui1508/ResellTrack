//
//  DetailsView.swift
//  ResellTrack
//
//  Created by Tien Bui on 10/7/2023.
//

import SwiftUI

struct DetailsView: View {
    var item: Item
    var body: some View {
            VStack {
                // TODO: add details view
                // photo
                
                Text(item.name)
                Text("Bought for: \(item.purchasePrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                Text("Purchased on: \(item.purchaseDate.formatted(date: .abbreviated, time: .omitted))")
                Text("Status: \(item.isResold ? "Resold" : "Available")")
                
                if item.isResold {
                    Text("Sold for: \(item.resellPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    if item.resellGain > 0 {
                        Text("Resell gain: \(item.resellPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                            .foregroundColor(.green)
                    } else if item.resellGain == 0 {
                        Text("Resold for the same price bought")
                            .foregroundColor(.yellow)
                    } else {
                        Text("Resell loss: \(item.resellPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                            .foregroundColor(.red)
                    }
                    
                    Text("Sold on: \(item.resellDate.formatted(date: .abbreviated, time: .omitted))")
                }
                    
            }
        
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(item: Item.exampleItem)
    }
}
