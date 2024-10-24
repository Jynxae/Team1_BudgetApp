//
//  FinanceMonthView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 10/19/24.
//

import SwiftUI

struct FinanceMonthView: View {
    
    var body: some View {
        ScrollView {
            VStack {
//                SegmentedControlView(tabs: tabs, selectedTab: $selectedTab)
                    FinanceMonthContentView()
                
                Spacer().frame(height: 30)
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
    }
}

// Reusable Component for Segmented Control
struct SegmentedControlView: View {
    let tabs: [String]
    @Binding var selectedTab: String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    Text(tab)
                        .font(.footnote) // Smaller text size
                        .fontWeight(.bold)
                        .foregroundColor(selectedTab == tab ? Color("PrimaryBlack") : Color.gray)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            ZStack {
                                if selectedTab == tab {
                                    Color.white
                                        .cornerRadius(10)
                                        .shadow(color: Color.gray.opacity(0.4), radius: 2, x: 0, y: 1)
                                } else {
                                    Color.clear
                                }
                            }
                        )
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

// Reusable Component for Monthly Finance Content
struct FinanceMonthContentView: View {
    var body: some View {
        VStack {
            SectionTitleView(title: "September Summary", color: "primaryPink")
            
            // Donut Chart Placeholder
            DonutChartView()
                .padding(.top, 20)
            
            // Spending Categories List
            VStack(alignment: .leading, spacing: 10) {
                SectionTitleView(title: "Your Spending Categories", color: "PrimaryBlack")
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                SpendingCategoriesList()
            }
            
            // Savings & Wants Status
           VStack(spacing: 20) {
               SectionTitleView(title: "You Saved", color: "PrimaryBlack")
                   .frame(alignment: .leading)
               
               SavingsProgressView(
                   title: "Savings Goal",
                   icon: "checkmark.seal.fill",
                   amount: "$1,145.40",
                   percentage: 100,
                   message: "Target Reached!",
                   color: .green
               )
               
               SavingsProgressView(
                   title: "Wants Spending",
                   icon: "exclamationmark.triangle.fill",
                   amount: "$1,845.40",
                   percentage: 120,
                   message: "Amount Exceeded",
                   color: .red
               )
           }
           .padding(.top, 20)
        }
    }
}

struct SavingsProgressView: View {
    var title: String
    var icon: String
    var amount: String
    var percentage: Double
    var message: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color("PrimaryBlack"))
                
                Spacer()
                
                Text(amount)
                    .font(.headline)
                    .bold()
                    .foregroundColor(color)
            }
            
            // Progress Bar
            ReportProgressBar(value: percentage, color: color)
            
            // Status message
            Text(message)
                .font(.subheadline)
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 15)
    }
}

struct ReportProgressBar: View {
    var value: Double
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(Color.gray.opacity(0.2))
                
                Rectangle()
                    .frame(width: CGFloat(min(self.value, 100) / 100) * geometry.size.width, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(color)
            }
        }
        .frame(height: 8)
    }
}

// Reusable Component for Donut Chart
struct DonutChartView: View {
    var body: some View {
        ZStack {
            Circle().trim(from: 0.0, to: 0.28).stroke(Color("BillsColor"), lineWidth: 20)
            Circle().trim(from: 0.28, to: 0.53).stroke(Color("HealthColor"), lineWidth: 20)
            Circle().trim(from: 0.53, to: 0.67).stroke(Color("GasColor"), lineWidth: 20)
            Circle().trim(from: 0.67, to: 0.75).stroke(Color("EntertainmentColor"), lineWidth: 20)
            Circle().trim(from: 0.75, to: 0.85).stroke(Color("MiscellaneousColor"), lineWidth: 20)
            Circle().trim(from: 0.85, to: 1.0).stroke(Color("primaryLightPink"), lineWidth: 20)
            
            // Text in the center of the donut chart
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

// Reusable Component for Section Titles
struct SectionTitleView: View {
    var title: String
    var color: String
    
    var body: some View {
        Text(title)
            .font(.title3).bold()
            .foregroundColor(Color(color))
            .padding(.top, 5)
    }
}

struct SpendingCategoriesList: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SpendingCategoryView(
                icon: "cart.fill",
                color: "primaryPink",
                label: "Groceries",
                amount: "$233.00",
                percentage: "32%"
            )
            SpendingCategoryView(
                icon: "film.fill",
                color: "EntertainmentColor",
                label: "Entertainment",
                amount: "$56.78",
                percentage: "8%"
            )
            SpendingCategoryView(
                icon: "bolt.fill",
                color: "BillsColor",
                label: "Bills/Utilities",
                amount: "$289.29",
                percentage: "40%"
            )
            SpendingCategoryView(
                icon: "car.fill",
                color: "GasColor",
                label: "Gas",
                amount: "$40.00",
                percentage: "5%"
            )
            SpendingCategoryView(
                icon: "heart.fill",
                color: "HealthColor",
                label: "Health/Wellness",
                amount: "$26.00",
                percentage: "4%"
            )
            SpendingCategoryView(
                icon: "ellipsis.circle.fill",
                color: "MiscellaneousColor",
                label: "Miscellaneous",
                amount: "$79.00",
                percentage: "11%"
            )
        }
        .padding()
        .background(Color("secondaryYellow"))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}

struct SpendingCategoryView: View {
    var icon: String
    var color: String
    var label: String
    var amount: String
    var percentage: String
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon inside colored circle
            ZStack {
                Circle()
                    .fill(Color(color))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            // Category name and amount
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .foregroundColor(Color("SecondaryBlack"))
                    .font(.subheadline)
                    .bold()
                Text(amount)
                    .foregroundColor(Color("GrayText"))
                    .font(.footnote)
            }
            
            Spacer()
            
            // Display percentage
            Text(percentage)
                .foregroundColor(Color("GrayText"))
                .font(.footnote)
                .bold()
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.7))
                .cornerRadius(5)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
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
