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
        ScrollView {
            // TODO: add photo to details view
            // photo goes here
            VStack {
                Text("Item name")
                Text(item.name)
                    .font(.title)
                    .foregroundStyle(.primary)
            }

            VStack(alignment: .leading) {
                Label("Status", systemImage: "info.circle.fill")
                    .foregroundStyle(.secondary)
                Text("\(item.isResold ? "Resold" : "Available")")
            }
                .detailStyle()

            VStack(alignment: .leading) {
                Label("Purchase", systemImage: "purchased.circle.fill")
                    .foregroundStyle(.secondary)
                Text("Price: \(item.purchasePrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                Text("Date: \(item.purchaseDate.formatted(date: .abbreviated, time: .omitted))")
            }
                .detailStyle()



            if item.isResold {
                VStack(alignment: .leading) {
                    Label("Resale", systemImage: "dollarsign.circle.fill")
                        .foregroundStyle(.secondary)
                    
                    Text("Price: \(item.resellPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    Text("Date: \(item.resellDate.formatted(date: .abbreviated, time: .omitted))")
                    
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
                }
                .detailStyle()
            }

            VStack(alignment: .leading) {
                Label("Item description", systemImage: "lightbulb.circle.fill")
                    .foregroundStyle(.secondary)
                Text(item.description)
            }
                .detailStyle()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailComponentView: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }
            .frame(maxWidth: .infinity)
            .padding()
            .background()
            .backgroundStyle(.thinMaterial)
            .cornerRadius(10)
            .padding(.horizontal)


    }
}

extension View {
    func detailStyle() -> some View {
        modifier(DetailComponentView())
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(item: Item.exampleItem)
    }
}
