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
        Text(item.name)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(item: Item.exampleItem)
    }
}
