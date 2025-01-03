import SwiftUI
import Charts

struct FinanceYearView: View {
    @StateObject private var financeViewModel = FinanceViewModel()
    @StateObject private var budgetViewModel = BudgetViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                SectionTitleView(title: "\(getCurrentYear()) Summary", color: "primaryPink")
                
                VStack(spacing: 20) {
                    YearlySummaryChart(
                        title: "Overall Spending Per Month",
                        color: "primaryPink",
                        data: getMonthlySpending()
                    )
                    
                    YearlySummaryChart(
                        title: "Overall Savings Per Month",
                        color: "primaryPink",
                        data: getMonthlySavings()
                    )
                }
                
                SpendingSummaryView(
                    totalSpent: getTotalYearlySpent(),
                    categories: getTopSpendingCategories()
                )
                
                Spacer().frame(height: 30)
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .environmentObject(financeViewModel)
        .environmentObject(budgetViewModel)
        .onAppear {
            financeViewModel.fetchTransactions()
            budgetViewModel.fetchBudgetData()
        }
    }
    
    // Helper functions
    func getCurrentYear() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        return String(currentYear)
    }
    
    func getMonthlySpending() -> [ChartData] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        return (1...12).map { month in
            let monthName = calendar.shortMonthSymbols[month - 1]
            let transactions = financeViewModel.transactions.filter { transaction in
                let components = calendar.dateComponents([.year, .month], from: transaction.date)
                return components.year == currentYear && components.month == month
            }
            let total = transactions.reduce(0) { $0 + $1.amount }
            return ChartData(label: monthName, value: total)
        }
    }
    
    func getMonthlySavings() -> [ChartData] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        return (1...12).map { month in
            let monthName = calendar.shortMonthSymbols[month - 1]
            let transactions = financeViewModel.transactions.filter { transaction in
                let components = calendar.dateComponents([.year, .month], from: transaction.date)
                return components.year == currentYear &&
                       components.month == month &&
                       transaction.type == .savings
            }
            let total = transactions.reduce(0) { $0 + $1.amount }
            return ChartData(label: monthName, value: total)
        }
    }
    
    func getTotalYearlySpent() -> String {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        let yearlyTransactions = financeViewModel.transactions.filter { transaction in
            calendar.component(.year, from: transaction.date) == currentYear
        }
        
        let total = yearlyTransactions.reduce(0) { $0 + $1.amount }
        return String(format: "%.2f", total)
    }
    
    func getTopSpendingCategories() -> [(String, String)] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        // Group transactions by subcategory
        let groupedTransactions = Dictionary(grouping: financeViewModel.transactions) { $0.subcategory }
        
        // Calculate total for each subcategory
        let categoryTotals = groupedTransactions.map { (category, transactions) in
            let yearTotal = transactions
                .filter { calendar.component(.year, from: $0.date) == currentYear }
                .reduce(0) { $0 + $1.amount }
            return (category, yearTotal)
        }
        
        // Sort by amount and take top 5
        let topCategories = categoryTotals
            .sorted { $0.1 > $1.1 }
            .prefix(5)
            .map { (category, amount) in
                (category, String(format: "$%.2f", amount))
            }
        
        return Array(topCategories)
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

struct YearlySummaryChart: View {
    var title: String
    var color: String
    var data: [ChartData]
    
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(color))
            
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Month", item.label),
                        y: .value("Amount", item.value)
                    )
                    .foregroundStyle(Color(color))
                }
            }
            .frame(height: 200)
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

// MARK: - Preview
#Preview {
    FinanceYearView()
}
