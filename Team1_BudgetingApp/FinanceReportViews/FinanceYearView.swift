import SwiftUI

struct FinanceYearView: View {
//    @State private var selectedTab: String = "Current Year"
//    let tabs = ["Current Month", "Current Year"]

    var body: some View {
            ScrollView {
                VStack {
                    // Example content for the yearly report
                    SectionTitleView(title: "\(getCurrentYear()) Summary", color: "primaryPink")
                    
                    VStack(spacing: 20) {
                        YearlySummaryChart(title: "Overall Spending Per Month", color: "primaryPink")
                        YearlySummaryChart(title: "Overall Savings Per Month", color: "primaryPink")
                    }

                    SpendingSummaryView(
                        totalSpent: "$50,793.56",
                        categories: [
                            ("Groceries", "$360.43"),
                            ("Entertainment", "$289.29"),
                            ("Bills/Utilities", "$230.96"),
                            ("Health/Wellness", "$40.00"),
                            ("Gas", "$26.00")
                        ]
                    )
                    
                    Spacer().frame(height: 30)
                }
                .padding(.bottom, 30)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
        }

    // Function to get the current year
    func getCurrentYear() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        return String(currentYear)
    }
}

// Example component for yearly charts (replace with actual implementation)
struct YearlySummaryChart: View {
    var title: String
    var color: String

    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(color))
            
            // Placeholder for a chart
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(color).opacity(0.3))
                .frame(height: 200)
                .overlay(
                    Text("Chart Placeholder")
                        .foregroundColor(Color(color))
                        .font(.subheadline)
                )
        }
        .padding()
        .background(Color("secondaryYellow"))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct SpendingSummaryView: View {
    var totalSpent: String
    var categories: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Total Spent Overall
            VStack(alignment: .leading) {
                Text("Total Spent Overall")
                    .font(.headline)
                    .foregroundColor(Color("primaryPink"))
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading) {
                    Text(totalSpent)
                        .font(.title3)
                        .foregroundColor(Color("PrimaryBlack"))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("secondaryYellow"))
                        .cornerRadius(10)
                }
            }

            // Top 5 Spending Categories
            VStack(alignment: .leading) {
                Text("Top 5 Spending Categories")
                    .font(.headline)
                    .foregroundColor(Color("primaryPink"))
                    .padding(.bottom, 5)
                
                VStack(alignment: .leading) {
                    ForEach(categories.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1). \(categories[index].0)")
                            Spacer()
                            Text(categories[index].1)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                    }
                }
                .background(Color("secondaryYellow"))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

// Preview
#Preview {
    FinanceYearView()
}
