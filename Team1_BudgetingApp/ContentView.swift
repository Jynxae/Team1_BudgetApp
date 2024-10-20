//
//  ContentView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    // adjusts background color for tabview
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "primaryLightPink") // Use your custom color
        UITabBar.appearance().barTintColor = UIColor(named: "primaryLightPink") // Ensures compatibility with dark mode
    }

    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                MyFinancesView().tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)
                
                EditBudgetView().tabItem {
                    if selectedTab == 1 {
                        Image("piggybank-fill") // Use "filled" version from assets if available
                    } else {
                        Image("piggybank") // Default piggybank image from assets
                    }
                    Text("Budget")
                }
                .tag(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
