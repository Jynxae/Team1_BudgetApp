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
            // Monthly Navigation
            HStack {
                Button(action: {
                    financeViewModel.moveToPreviousMonth()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(!financeViewModel.hasPreviousTransactionsMonth ? .gray : .primary)
                }
                .disabled(!financeViewModel.hasPreviousTransactionsMonth)
                
                Text(financeViewModel.monthString(for: financeViewModel.selectedMonth))
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color("primaryPink"))
                
                Button(action: {
                    financeViewModel.moveToNextMonth()
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(financeViewModel.isFutureMonth ? .gray : .primary)
                }
                .disabled(financeViewModel.isFutureMonth)
            }
            .padding(.vertical, 10)
            
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
                    amount: String(format: "$%.2f", financeViewModel.transactionsForSelectedMonth.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }),
                    percentage: (financeViewModel.transactionsForSelectedMonth.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount } / (budgetViewModel.savingsGoal / 100 * Double(budgetViewModel.monthlyIncome)!)) * 100,
                    message: getSavingsMessage(),
                    color: getSavingsMessage() == "Goal Reached!" ? .green : Color("primaryPink")
                )
                
                SavingsProgressView(
                    title: "Needs Budget",
                    icon: "cart.fill",
                    amount: String(format: "$%.2f", financeViewModel.transactionsForSelectedMonth.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }),
                    percentage: (financeViewModel.transactionsForSelectedMonth.filter { $0.type == .need }.reduce(0) { $0 + $1.amount } / (budgetViewModel.needsGoal / 100 * Double(budgetViewModel.monthlyIncome)!)) * 100,
                    message: getNeedsMessage(),
                    color: getNeedsMessage() == "Over Budget" ? .red : Color("primaryPink")
                )
                
                SavingsProgressView(
                    title: "Wants Budget",
                    icon: "gift.fill",
                    amount: String(format: "$%.2f", financeViewModel.transactionsForSelectedMonth.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }),
                    percentage: (financeViewModel.transactionsForSelectedMonth.filter { $0.type == .want }.reduce(0) { $0 + $1.amount } / (budgetViewModel.wantsGoal / 100 * Double(budgetViewModel.monthlyIncome)!)) * 100,
                    message: getWantsMessage(),
                    color: getWantsMessage() == "Over Budget" ? .red : Color("primaryPink")
                )
            }
            .padding(.top, 20)
        }
    }
    
    private func getSavingsMessage() -> String {
        let monthlyTransactions = financeViewModel.transactionsForSelectedMonth
        let savingsTotal = monthlyTransactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }
        let currentPercentage = savingsTotal / (Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: "")) ?? 1) * 100
        return currentPercentage >= budgetViewModel.savingsGoal ? "Goal Reached!" : "Below Target"
    }
    
    private func getNeedsMessage() -> String {
        let monthlyTransactions = financeViewModel.transactionsForSelectedMonth
        let needsTotal = monthlyTransactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }
        let currentPercentage = needsTotal / (Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: "")) ?? 1) * 100
        return currentPercentage <= budgetViewModel.needsGoal ? "Within Budget" : "Over Budget"
    }
    
    private func getWantsMessage() -> String {
        let monthlyTransactions = financeViewModel.transactionsForSelectedMonth
        let wantsTotal = monthlyTransactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }
        let currentPercentage = wantsTotal / (Double(budgetViewModel.monthlyIncome.replacingOccurrences(of: "$", with: "")) ?? 1) * 100
        return currentPercentage <= budgetViewModel.wantsGoal ? "Within Budget" : "Over Budget"
    }
}

// Keeping your existing components with monthly transaction updates:

struct DonutChartView: View {
    @EnvironmentObject var financeViewModel: FinanceViewModel
    
    var monthlyTransactions: [Transaction] {
        financeViewModel.transactionsForSelectedMonth
    }
    
    var totalSpent: Double {
        monthlyTransactions.reduce(0) { $0 + $1.amount }
    }
    
    var needsTotal: Double {
        monthlyTransactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }
    }
    
    var wantsTotal: Double {
        monthlyTransactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }
    }
    
    var savingsTotal: Double {
        monthlyTransactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        ZStack {
            if totalSpent > 0 {
                Circle()
                    .trim(from: 0, to: CGFloat(needsTotal / totalSpent))
                    .stroke(Color("BillsColor"), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .trim(from: CGFloat(needsTotal / totalSpent),
                          to: CGFloat((needsTotal + wantsTotal) / totalSpent))
                    .stroke(Color("wantsColor"), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .trim(from: CGFloat((needsTotal + wantsTotal) / totalSpent),
                          to: 1)
                    .stroke(Color("savingsColor"), lineWidth: 20)
                    .rotationEffect(.degrees(-90))
            }
            
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

struct SpendingCategoriesList: View {
    @EnvironmentObject var financeViewModel: FinanceViewModel
    
    var monthlyTransactions: [Transaction] {
        financeViewModel.transactionsForSelectedMonth
    }
    
    var totalSpent: Double {
        monthlyTransactions.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SpendingCategoryView(
                icon: "banknote.fill",
                color: "savingsColor",
                label: "Savings",
                amount: String(format: "$%.2f", monthlyTransactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }),
                percentage: String(format: "%.0f%%", totalSpent > 0 ? (monthlyTransactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount } / totalSpent) * 100 : 0)
            )
            
            SpendingCategoryView(
                icon: "cart.fill",
                color: "BillsColor",
                label: "Needs",
                amount: String(format: "$%.2f", monthlyTransactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }),
                percentage: String(format: "%.0f%%", totalSpent > 0 ? (monthlyTransactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount } / totalSpent) * 100 : 0)
            )
            
            SpendingCategoryView(
                icon: "gift.fill",
                color: "wantsColor",
                label: "Wants",
                amount: String(format: "$%.2f", monthlyTransactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }),
                percentage: String(format: "%.0f%%", totalSpent > 0 ? (monthlyTransactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount } / totalSpent) * 100 : 0)
            )
        }
        .padding()
        .background(Color("secondaryYellow"))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// Keep your existing helper views exactly as they are
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

struct ReportProgressBar: View {
    var value: Double = 0.0
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
