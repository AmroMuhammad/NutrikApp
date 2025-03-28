//
//  TabBarView.swift
//  NutrationApp
//
//  Created by Amr Muhammad on 28/03/2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationView {
                CameraScannerView()
            }
            .tabItem {
                Label("Scan", systemImage: "camera.viewfinder")
            }
            .edgesIgnoringSafeArea(.top)
            
        }
        .accentColor(.green)
    }
}

#Preview {
    TabBarView()
}
