import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import Combine

class FinanceViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    
    // Arbitrary Totals (Could be fetched or modified dynamically)
    @Published var totalIncome: Double = 0.00
    @Published var needsTotal: Double = 0.00
    @Published var wantsTotal: Double = 0.00
    @Published var savingsTotal: Double = 0.00
    @Published var remainingIncome: Double = 0.00
    
    @Published var transactions: [Transaction] = [] // Updated to start empty
    
    let db = Firestore.firestore()
    
    init() {
        fetchIncomeData()
    }
    
    func fetchIncomeData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }

        let userDocRef = db.collection("users").document(userId)

        userDocRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                if let data = document.data(),
                   let userBudget = data["user_budget"] as? [String: Any] {

                    // Parse nested Firestore data
                    self.totalIncome = userBudget["monthly_income"] as? Double ?? 0.0
                    self.recalculateTotals()
                } else {
                    print("User budget data does not exist")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
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
        return CGFloat(remainingIncome / totalIncome)
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

    // Delete a single transaction and remove it from Firestore
    func deleteTransaction(_ transaction: Transaction) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not signed in.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("transactions")
            .document(transaction.id.uuidString)
            .delete { error in
                if let error = error {
                    print("Error deleting transaction from Firestore: \(error.localizedDescription)")
                } else {
                    print("Transaction successfully deleted from Firestore.")
                    DispatchQueue.main.async {
                        // Remove the transaction locally
                        if let index = self.transactions.firstIndex(where: { $0.id == transaction.id }) {
                            self.transactions.remove(at: index)
                            self.recalculateTotals()
                        }
                    }
                }
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
        remainingIncome = totalIncome - (needsTotal + wantsTotal + savingsTotal)
    }

}
