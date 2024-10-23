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
                        totalSpent: "50,793.56",
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
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct SpendingSummaryView: View {
    var totalSpent: String
    var categories: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Total Spent Overall Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Total Spent Overall")
                    .font(.headline)
                    .foregroundColor(Color("primaryPink"))
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title)
                        .foregroundColor(Color("primaryPink"))
                    
                    Text(totalSpent)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primaryBlack)
                    
                    Spacer()
                }
                .padding()
                .background(Color("secondaryYellow"))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            
            // Top 5 Spending Categories Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Top 5 Spending Categories")
                    .font(.headline)
                    .foregroundColor(Color("primaryPink"))
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(categories.indices, id: \.self) { index in
                        HStack(spacing: 10) {
                            // Icon with background circle
                            ZStack {
                                Circle()
                                    .fill(Color("primaryPink").opacity(0.2))
                                    .frame(width: 36, height: 36)
                                
                                Text("\(index + 1)")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("primaryPink"))
                            }
                            
                            // Category name and amount
                            VStack(alignment: .leading, spacing: 2) {
                                Text(categories[index].0)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("PrimaryBlack"))
                                
                                Text(categories[index].1)
                                    .font(.footnote)
                                    .foregroundColor(Color("GrayText"))
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
                .padding()
                .background(Color("secondaryYellow"))
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
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
