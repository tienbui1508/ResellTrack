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
            Text(item.name)
            Text("\(String(format: "%.0f", item.boughtPrice))")
            Text("\(item.boughtDate)")
                
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(item: Item.exampleItem)
    }
}
