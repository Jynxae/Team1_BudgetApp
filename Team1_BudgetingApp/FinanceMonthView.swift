//
//  FinanceMonthView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 10/19/24.
//

import SwiftUI

struct FinanceMonthView: View {
    @State private var selectedTab: String = "Current Month"
    let tabs = ["Current Month", "Current Year"]
    
    var body: some View {
        ScrollView {
            VStack {
                HeaderView(title: "Finance Report", color: "PrimaryLightPink")
                
                SegmentedControlView(tabs: tabs, selectedTab: $selectedTab)
                
                // September Summary Title
                SectionTitleView(title: "September Summary", color: "PrimaryPink")
                    .font(.title2).bold()
                
                // Donut Chart Placeholder
                DonutChartView()
                    .padding(.top, 20)
                
                // Spending Categories List
                VStack(alignment: .leading, spacing: 10) {
                    SectionTitleView(title: "Your Spending Categories", color: "PrimaryBlack")
                    
                    SpendingCategoriesList()
                }
                .padding(.horizontal)
                
                // Savings & Wants Status
                VStack(alignment: .leading, spacing: 10) {
                    SectionTitleView(title: "You Saved", color: "PrimaryBlack")
                        .padding(.horizontal)
                    StatusView(amount: "$1,145.40", message: "Target Reached!", color: .green)
                    SectionTitleView(title: "Amount Spent on Wants", color: "PrimaryBlack")
                        .padding(.horizontal)
                    StatusView(amount: "$1,845.40", message: "Amount Exceeded", color: .red)
                }
                
                Spacer().frame(height: 30)
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
    }
}

// Reusable Header Component
struct HeaderView: View {
    var title: String
    var color: String
    
    var body: some View {
        VStack {
            Spacer().frame(height: 15)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 50)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color(color))
    }
}

// Reusable Segmented Control Component
struct SegmentedControlView: View {
    let tabs: [String]
    @Binding var selectedTab: String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    Text(tab)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == tab ? Color("PrimaryBlack") : Color.gray)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(selectedTab == tab ? Color.white : Color.clear)
                        .cornerRadius(10)
                        .shadow(color: selectedTab == tab ? Color.gray.opacity(0.4) : Color.clear, radius: 2, x: 0, y: 1)
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .padding(.top, 15)
    }
}

// Reusable Section Title Component
struct SectionTitleView: View {
    var title: String
    var color: String
    
    var body: some View {
        Text(title)
            .foregroundColor(Color(color))
            .padding(.top, 5)
    }
}

// Reusable Donut Chart View
struct DonutChartView: View {
    var body: some View {
        ZStack {
            Circle().trim(from: 0.0, to: 0.28).stroke(Color("BillsColor"), lineWidth: 20)
            Circle().trim(from: 0.28, to: 0.53).stroke(Color("HealthColor"), lineWidth: 20)
            Circle().trim(from: 0.53, to: 0.67).stroke(Color("GasColor"), lineWidth: 20)
            Circle().trim(from: 0.67, to: 0.75).stroke(Color("EntertainmentColor"), lineWidth: 20)
            Circle().trim(from: 0.75, to: 0.85).stroke(Color("MiscellaneousColor"), lineWidth: 20)
            Circle().trim(from: 0.85, to: 1.0).stroke(Color("PrimaryLightPink"), lineWidth: 20)
            
            VStack {
                Text("You've Spent")
                    .foregroundColor(Color("PrimaryBlack"))
                    .font(.subheadline)
                Text("$724.07")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryBlack"))
            }
        }
        .frame(width: 200, height: 200)
    }
}

// Reusable Spending Categories List
struct SpendingCategoriesList: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SpendingCategoryView(color: "PrimaryPink", label: "Groceries", amount: "$233.00")
            SpendingCategoryView(color: "EntertainmentColor", label: "Entertainment", amount: "$56.78")
            SpendingCategoryView(color: "BillsColor", label: "Bills/Utilities", amount: "$289.29")
            SpendingCategoryView(color: "GasColor", label: "Gas", amount: "$40.00")
            SpendingCategoryView(color: "HealthColor", label: "Health/Wellness", amount: "$26.00")
            SpendingCategoryView(color: "MiscellaneousColor", label: "Miscellaneous", amount: "$79.00")
        }
        .padding()
        .background(Color("secondaryYellow"))
        .cornerRadius(10)
    }
}

// Reusable Component for Spending Categories
struct SpendingCategoryView: View {
    var color: String
    var label: String
    var amount: String
    
    var body: some View {
        HStack {
            Circle().fill(Color(color)).frame(width: 15, height: 15)
            Text(label).foregroundColor(Color("SecondaryBlack")).font(.subheadline)
            Spacer()
            Text(amount).foregroundColor(Color("SecondaryBlack")).font(.subheadline)
        }
    }
}

// Reusable Component for Status
struct StatusView: View {
    var amount: String
    var message: String
    var color: Color
    
    var body: some View {
        HStack {
            Text(amount).foregroundColor(Color("GrayText"))
            Spacer()
            Text(message)
                .foregroundColor(color)
                .padding(.horizontal, 10)
                .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color("secondaryYellow"))
        .cornerRadius(10)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

// Preview
#Preview {
    FinanceMonthView()
}
