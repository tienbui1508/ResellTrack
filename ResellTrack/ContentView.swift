//
//  ContentView.swift
//  ResellTrack
//
//  Created by Tien Bui on 15/6/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var data = Items()

    var body: some View {
        TabView {
            ItemsView(filter: .available)
                .tabItem {
                Label("Available", systemImage: "checkmark.circle")
            }

            ItemsView(filter: .resold)
                .tabItem {
                Label("Resold", systemImage: "dollarsign.arrow.circlepath")
            }

            ItemsView(filter: .none)
                .tabItem {
                Label("All", systemImage: "eye")
            }

        }
        .environmentObject(data)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
