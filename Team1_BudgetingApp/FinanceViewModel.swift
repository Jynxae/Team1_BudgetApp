//
//  FinanceViewModel.swift
//  Team1_BudgetingApp
//
//  Created by Sue on 10/19/24.
//

import Foundation
import SwiftUI
import Combine

class FinanceViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    
    // Arbitrary Totals (Could be fetched or modified dynamically)
    @Published var totalIncome: Double = 1000.00
    @Published var needsTotal: Double = 400.00
    @Published var wantsTotal: Double = 250.00
    @Published var savingsTotal: Double = 150.00
    
    @Published var transactions: [Transaction] = transactionRows // Initialize with sample data
    
    // Compute Remaining Income
    var remainingTotal: Double {
        totalIncome - (needsTotal + wantsTotal + savingsTotal)
    }
    
    // Compute percentages
    var needsPercentage: CGFloat {
        guard totalIncome > 0 else { return 0 }
        return CGFloat(needsTotal / totalIncome)
    }
    
    var wantsPercentage: CGFloat {
        guard totalIncome > 0 else { return 0 }
        return CGFloat(wantsTotal / totalIncome)
    }
    
    var savingsPercentage: CGFloat {
        guard totalIncome > 0 else { return 0 }
        return CGFloat(savingsTotal / totalIncome)
    }
    
    var remainingIncomePercentage: CGFloat {
        guard totalIncome > 0 else { return 0 }
        return CGFloat(remainingTotal / totalIncome)
    }
    
    // Date Navigation Functions
    func moveToPreviousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    }
    
    func moveToNextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
    }
    
    // Date Formatting
    func dateString(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    // Determine if the selected date is in the future
    var isFutureDate: Bool {
        return selectedDate > Date()
    }
    
    // Add a new transaction
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        recalculateTotals()
    }
    
    // Delete transactions
    func deleteTransactions(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
        recalculateTotals()
    }
    
    // Recalculate Totals based on transactions
    private func recalculateTotals() {
        needsTotal = transactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }
        wantsTotal = transactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }
        savingsTotal = transactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }
    }
}

