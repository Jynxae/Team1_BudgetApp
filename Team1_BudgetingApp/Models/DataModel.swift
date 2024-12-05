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
    
    func nextScheduledDate(from date: Date) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        switch recurrenceFrequency {
        case .daily:
            dateComponents.day = 1
        case .weekly:
            dateComponents.day = 7
        case .monthly:
            dateComponents.month = 1
        default:
            return nil // Handle transactions without recurrence
        }
        
        return calendar.date(byAdding: dateComponents, to: date)
    }
}

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
