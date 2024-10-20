//
//  DataModel.swift
//  Team1_BudgetingApp
//
//  Created by Sue on 10/19/24.
//
//  Data model for transactions

import Foundation
import SwiftUI

// Define the type of transaction
enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case need = "Need"
    case want = "Want"
    case savings = "Savings"
    
    // Conformance to Identifiable
    var id: String { self.rawValue }
}

// Define the Transaction model
struct Transaction: Identifiable, Codable {
    var id = UUID() // Unique identifier for each transaction
    let name: String
    let type: TransactionType
    let subcategory: String
    let date: Date
    let notes: String
    let amount: Double // New property
}

// Sample Data for Transactions
let transactionRows: [Transaction] = [
    Transaction(
        name: "Kroger's Run",
        type: .need,
        subcategory: "Groceries",
        date: Date(),
        notes: "Bought a lil too much today",
        amount: 131.45
    ),
    Transaction(
        name: "Electric Bill",
        type: .need,
        subcategory: "Utilities",
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
        notes: "Paid before due date",
        amount: 75.00
    ),
    Transaction(
        name: "Dinner at Olive Garden",
        type: .want,
        subcategory: "Eating Out",
        date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
        notes: "Family dinner",
        amount: 45.00
    ),
    Transaction(
        name: "Monthly Savings",
        type: .savings,
        subcategory: "Emergency Fund",
        date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
        notes: "Transferred to savings account",
        amount: 200.00
    ),
    Transaction(
        name: "Netflix Subscription",
        type: .want,
        subcategory: "Entertainment",
        date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
        notes: "Monthly subscription fee",
        amount: 15.99
    ),
    Transaction(
        name: "Gym Membership Refund",
        type: .savings,
        subcategory: "Health",
        date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
        notes: "Annual membership payment",
        amount: 300.00
    )
]

// Helper function to determine color based on transaction type
func colorForType(_ type: TransactionType) -> Color {
    switch type {
    case .need:
        return Color.needs
    case .want:
        return Color.wants
    case .savings:
        return Color.savings
    }
}

// Helper function to determine icon based on transaction type
func iconName(for type: TransactionType) -> String {
    switch type {
    case .need:
        return "cart.fill"
    case .want:
        return "gift.fill"
    case .savings:
        return "banknote.fill"
    }
}
