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

enum RecurrenceFrequency: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

// Define the Transaction model
struct Transaction: Identifiable, Codable, Hashable {
    var id = UUID() // Unique identifier for each transaction
    var name: String
    var type: TransactionType
    var subcategory: String
    var date: Date
    var notes: String
    var amount: Double
    var isRecurring: Bool // New Property
    var recurrenceFrequency: RecurrenceFrequency? // New Property
    
    // Initializer with default values for recurring properties
    init(
        id: UUID = UUID(),
        name: String,
        type: TransactionType,
        subcategory: String,
        date: Date,
        notes: String,
        amount: Double,
        isRecurring: Bool = false,
        recurrenceFrequency: RecurrenceFrequency? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.subcategory = subcategory
        self.date = date
        self.notes = notes
        self.amount = amount
        self.isRecurring = isRecurring
        self.recurrenceFrequency = recurrenceFrequency
    }
}

// Sample Data for Transactions
let transactionRows: [Transaction] = [
    // Non-Recurring Transactions
    Transaction(
        name: "Kroger's Run",
        type: .need,
        subcategory: "Groceries",
        date: Date(),
        notes: "Bought a little too much today",
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
        subcategory: "Dining Out",
        date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
        notes: "Family dinner",
        amount: 45.00
    ),
    Transaction(
        name: "Gym Membership Refund",
        type: .savings,
        subcategory: "Health",
        date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
        notes: "Annual membership payment",
        amount: 300.00
    ),
    
    // Recurring Transactions
    Transaction(
        name: "Monthly Savings",
        type: .savings,
        subcategory: "Emergency Fund",
        date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
        notes: "Transferred to savings account",
        amount: 200.00,
        isRecurring: true,
        recurrenceFrequency: .monthly
    ),
    Transaction(
        name: "Netflix Subscription",
        type: .want,
        subcategory: "Entertainment",
        date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
        notes: "Monthly subscription fee",
        amount: 15.99,
        isRecurring: true,
        recurrenceFrequency: .monthly
    ),
    Transaction(
        name: "Annual Insurance",
        type: .need,
        subcategory: "Insurance",
        date: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
        notes: "Car insurance renewal",
        amount: 600.00,
        isRecurring: true,
        recurrenceFrequency: .yearly
    ),
    Transaction(
        name: "Weekly Groceries",
        type: .need,
        subcategory: "Groceries",
        date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!,
        notes: "Weekly grocery shopping",
        amount: 90.00,
        isRecurring: true,
        recurrenceFrequency: .weekly
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
