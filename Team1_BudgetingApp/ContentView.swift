//
//  ContentView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                MyFinancesView(selectedTab: $selectedTab).tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
                
                EditBudgetView().tabItem {
                    if selectedTab == 2 {
                        Image("piggybank-fill") // Use "filled" version from assets if available
                    } else {
                        Image("piggybank") // Default piggybank image from assets
                    }
                    Text("Budget")
                }
                .tag(2)
                
                FinanceMonthView().tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Reports")
                }
                .tag(3)
                
                ProfileView().tabItem {
                    Image(systemName: "person.fill")
                    Text("My Profile")
                }
                .tag(4)
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(named: "primaryLightPink") // Use your custom color
            UITabBar.appearance().barTintColor = UIColor(named: "primaryLightPink") // Ensures compatibility with dark mode
        }
    }
}

//#Preview {
//    ContentView()
//}
