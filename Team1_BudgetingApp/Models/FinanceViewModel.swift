import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import Combine

class FinanceViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    
    // Arbitrary Totals (Could be fetched or modified dynamically)
    @Published var totalIncome: Double = 1000.00
    @Published var needsTotal: Double = 400.00
    @Published var wantsTotal: Double = 250.00
    @Published var savingsTotal: Double = 150.00
    
    @Published var transactions: [Transaction] = [] // Updated to start empty
    
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
        let currentDate = Calendar.current.startOfDay(for: Date())
        let selectedDateStartOfDay = Calendar.current.startOfDay(for: selectedDate)
        return selectedDateStartOfDay >= currentDate
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
    
    // Delete a single transaction
    func deleteTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions.remove(at: index)
            recalculateTotals()
        }
    }
    
    func updateTransaction(transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        }
    }
    
    // Fetch user-specific transactions from Firestore
    func fetchTransactions() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not signed in.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("transactions")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching transactions: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No transactions found.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.transactions = documents.compactMap { document -> Transaction? in
                        let data = document.data()
                        guard
                            let idString = data["id"] as? String,
                            let id = UUID(uuidString: idString),
                            let name = data["name"] as? String,
                            let typeString = data["type"] as? String,
                            let type = TransactionType(rawValue: typeString),
                            let subcategory = data["subcategory"] as? String,
                            let date = (data["date"] as? Timestamp)?.dateValue(),
                            let notes = data["notes"] as? String,
                            let amount = data["amount"] as? Double,
                            let isRecurring = data["isRecurring"] as? Bool
                        else {
                            return nil
                        }
                        
                        let recurrenceFrequency = data["recurrenceFrequency"] as? String
                        return Transaction(
                            id: id,
                            name: name,
                            type: type,
                            subcategory: subcategory,
                            date: date,
                            notes: notes,
                            amount: amount,
                            isRecurring: isRecurring,
                            recurrenceFrequency: recurrenceFrequency.flatMap { RecurrenceFrequency(rawValue: $0) }
                        )
                    }
                    self.recalculateTotals()
                }
            }
    }
    
    // Recalculate Totals based on transactions
    func recalculateTotals() {
        needsTotal = transactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }
        wantsTotal = transactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }
        savingsTotal = transactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }
    }

}
