import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// MARK: - Main View
struct FinanceMonthView: View {
    @StateObject private var financeViewModel = FinanceViewModel()
    @StateObject private var budgetViewModel = BudgetViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                FinanceMonthContentView()
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
}

// MARK: - Monthly Finance Content
struct FinanceMonthContentView: View {
    @EnvironmentObject var financeViewModel: FinanceViewModel
    @EnvironmentObject var budgetViewModel: BudgetViewModel
    
    var body: some View {
        VStack {
            SectionTitleView(title: "Monthly Summary", color: "primaryPink")
            
            DonutChartView()
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                SectionTitleView(title: "Your Spending Categories", color: "PrimaryBlack")
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                SpendingCategoriesList()
            }
            
            VStack(spacing: 20) {
                SectionTitleView(title: "Budget Goals", color: "PrimaryBlack")
                    .frame(alignment: .leading)
                
                SavingsProgressView(
                    title: "Savings Progress",
                    icon: "banknote.fill",
                    amount: String(format: "$%.2f", financeViewModel.savingsTotal),
                    percentage: budgetViewModel.savingsGoal,
                    message: getSavingsMessage(),
                    color: Color("primaryPink")  // Changed to primaryPink
                )
                
                SavingsProgressView(
                    title: "Needs Budget",
                    icon: "cart.fill",
                    amount: String(format: "$%.2f", financeViewModel.needsTotal),
                    percentage: budgetViewModel.needsGoal,
                    message: getNeedsMessage(),
                    color: Color("primaryPink")  // Changed to primaryPink
                )
                
                SavingsProgressView(
                    title: "Wants Budget",
                    icon: "gift.fill",
                    amount: String(format: "$%.2f", financeViewModel.wantsTotal),
                    percentage: budgetViewModel.wantsGoal,
                    message: getWantsMessage(),
                    color: Color("primaryPink")  // Changed to primaryPink
                )
            }
            .padding(.top, 20)
        }
    }
    
    private func getSavingsMessage() -> String {
        let currentPercentage = financeViewModel.savingsTotal / Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: ""))! * 100
        return currentPercentage >= budgetViewModel.savingsGoal ? "On Track" : "Below Target"
    }
    
    private func getNeedsMessage() -> String {
        let currentPercentage = financeViewModel.needsTotal / Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: ""))! * 100
        return currentPercentage <= budgetViewModel.needsGoal ? "Within Budget" : "Over Budget"
    }
    
    private func getWantsMessage() -> String {
        let currentPercentage = financeViewModel.wantsTotal / Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: ""))! * 100
        return currentPercentage <= budgetViewModel.wantsGoal ? "Within Budget" : "Over Budget"
    }
    
    private func getSavingsColor() -> Color {
        let currentPercentage = financeViewModel.savingsTotal / Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: ""))! * 100
        return currentPercentage >= budgetViewModel.savingsGoal ? .green : .blue
    }
    
    private func getNeedsColor() -> Color {
        let currentPercentage = financeViewModel.needsTotal / Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: ""))! * 100
        return currentPercentage <= budgetViewModel.needsGoal ? .blue : .red
    }
    
    private func getWantsColor() -> Color {
        let currentPercentage = financeViewModel.wantsTotal / Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: ""))! * 100
        return currentPercentage <= budgetViewModel.wantsGoal ? .blue : .red
    }
}

// MARK: - Progress Views
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
            
            ReportProgressBar(value: percentage, color: color)
            
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

// MARK: - Progress Bar
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

// MARK: - Donut Chart
struct DonutChartView: View {
    @EnvironmentObject var financeViewModel: FinanceViewModel
    @EnvironmentObject var budgetViewModel: BudgetViewModel
    
    var totalSpent: Double {
        financeViewModel.needsTotal + financeViewModel.wantsTotal + financeViewModel.savingsTotal
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(financeViewModel.needsTotal / totalSpent))
                .stroke(Color("BillsColor"), lineWidth: 20)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: CGFloat(financeViewModel.needsTotal / totalSpent),
                      to: CGFloat((financeViewModel.needsTotal + financeViewModel.wantsTotal) / totalSpent))
                .stroke(Color("wantsColor"), lineWidth: 20)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: CGFloat((financeViewModel.needsTotal + financeViewModel.wantsTotal) / totalSpent),
                      to: 1)
                .stroke(Color("savingsColor"), lineWidth: 20)
                .rotationEffect(.degrees(-90))
            
            VStack {
                Text("Total Spent")
                    .foregroundColor(Color("PrimaryBlack"))
                    .font(.subheadline)
                Text(String(format: "$%.2f", totalSpent))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryBlack"))
            }
        }
        .frame(width: 200, height: 200)
    }
}

// MARK: - Spending Categories
struct SpendingCategoriesList: View {
    @EnvironmentObject var financeViewModel: FinanceViewModel
    
    var totalSpent: Double {
        financeViewModel.needsTotal + financeViewModel.wantsTotal + financeViewModel.savingsTotal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SpendingCategoryView(
                icon: "banknote.fill",
                color: "savingsColor",
                label: "Savings",
                amount: String(format: "$%.2f", financeViewModel.savingsTotal),
                percentage: String(format: "%.0f%%", (financeViewModel.savingsTotal / totalSpent) * 100)
            )
            
            SpendingCategoryView(
                icon: "cart.fill",
                color: "BillsColor",
                label: "Needs",
                amount: String(format: "$%.2f", financeViewModel.needsTotal),
                percentage: String(format: "%.0f%%", (financeViewModel.needsTotal / totalSpent) * 100)
            )
            
            SpendingCategoryView(
                icon: "gift.fill",
                color: "wantsColor",
                label: "Wants",
                amount: String(format: "$%.2f", financeViewModel.wantsTotal),
                percentage: String(format: "%.0f%%", (financeViewModel.wantsTotal / totalSpent) * 100)
            )
        }
        .padding()
        .background(Color("secondaryYellow"))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Category View
struct SpendingCategoryView: View {
    var icon: String
    var color: String
    var label: String
    var amount: String
    var percentage: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color(color))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
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

// MARK: - Section Title
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

#Preview {
    FinanceMonthView()
}
