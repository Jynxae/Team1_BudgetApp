import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import Combine

class FinanceViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedMonth: Date = Date()
    @Published var totalIncome: Double = 1000.00
    @Published var needsTotal: Double = 400.00
    @Published var wantsTotal: Double = 250.00
    @Published var savingsTotal: Double = 150.00
    @Published var transactions: [Transaction] = []
    
    // Arbitrary Totals (Could be fetched or modified dynamically)
    @Published var totalIncome: Double = 0.00
    @Published var needsTotal: Double = 0.00
    @Published var wantsTotal: Double = 0.00
    @Published var savingsTotal: Double = 0.00
    @Published var remainingIncome: Double = 0.00
    
    // MARK: - Computed Properties
    
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
    
    // MARK: - Transaction Filtering
    
    var transactionsForSelectedDate: [Transaction] {
        transactions.filter { transaction in
            Calendar.current.isDate(transaction.date, inSameDayAs: selectedDate)
        }
    }
    
    var transactionsForSelectedMonth: [Transaction] {
        transactions.filter { transaction in
            Calendar.current.isDate(transaction.date, equalTo: selectedMonth, toGranularity: .month)
        }
    }
    
    // MARK: - Date Navigation
    
    func moveToPreviousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
        recalculateDailyTotals()
    }
    
    func moveToNextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
        recalculateDailyTotals()
    }
    
    func moveToPreviousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
        recalculateMonthlyTotals()
    }
    
    func moveToNextMonth() {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
        if nextMonth <= Date() {
            selectedMonth = nextMonth
            recalculateMonthlyTotals()
        }
    }
    
    // MARK: - Date Formatting
    
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
    
    func monthString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    var isFutureDate: Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let selectedDateStartOfDay = Calendar.current.startOfDay(for: selectedDate)
        return selectedDateStartOfDay >= currentDate
    }
    
    // MARK: - Transaction Management
    
    func addTransaction(_ transaction: Transaction) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not signed in.")
            return
        }
        
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "id": transaction.id.uuidString,
            "name": transaction.name,
            "type": transaction.type.rawValue,
            "subcategory": transaction.subcategory,
            "date": Timestamp(date: transaction.date),
            "notes": transaction.notes,
            "amount": transaction.amount,
            "isRecurring": transaction.isRecurring,
            "recurrenceFrequency": transaction.recurrenceFrequency?.rawValue ?? ""
        ]
        
        db.collection("users")
            .document(userId)
            .collection("transactions")
            .document(transaction.id.uuidString)
            .setData(data) { error in
                if let error = error {
                    print("Error adding transaction: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.transactions.append(transaction)
                        self.recalculateTotals()
                    }
                }
            }
    }
    
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
                    print("Error deleting transaction: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.transactions.removeAll { $0.id == transaction.id }
                        self.recalculateTotals()
                    }
                }
            }
    }
    
    func updateTransaction(transaction: Transaction) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not signed in.")
            return
        }
        
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "id": transaction.id.uuidString,
            "name": transaction.name,
            "type": transaction.type.rawValue,
            "subcategory": transaction.subcategory,
            "date": Timestamp(date: transaction.date),
            "notes": transaction.notes,
            "amount": transaction.amount,
            "isRecurring": transaction.isRecurring,
            "recurrenceFrequency": transaction.recurrenceFrequency?.rawValue ?? ""
        ]
        
        db.collection("users")
            .document(userId)
            .collection("transactions")
            .document(transaction.id.uuidString)
            .setData(data) { error in
                if let error = error {
                    print("Error updating transaction: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        if let index = self.transactions.firstIndex(where: { $0.id == transaction.id }) {
                            self.transactions[index] = transaction
                            self.recalculateTotals()
                        }
                    }
                }
            }
    }
    
    // MARK: - Total Calculations
    
    func recalculateTotals() {
        recalculateDailyTotals()
        recalculateMonthlyTotals()
      
        needsTotal = transactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }
        wantsTotal = transactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }
        savingsTotal = transactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }
        remainingIncome = totalIncome - (needsTotal + wantsTotal + savingsTotal)
    }
    
    private func recalculateDailyTotals() {
        let dailyTransactions = transactionsForSelectedDate
        needsTotal = dailyTransactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }
        wantsTotal = dailyTransactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }
        savingsTotal = dailyTransactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }
    }
    
    private func recalculateMonthlyTotals() {
        let monthlyTransactions = transactionsForSelectedMonth
        needsTotal = monthlyTransactions.filter { $0.type == .need }.reduce(0) { $0 + $1.amount }
        wantsTotal = monthlyTransactions.filter { $0.type == .want }.reduce(0) { $0 + $1.amount }
        savingsTotal = monthlyTransactions.filter { $0.type == .savings }.reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - Data Fetching
    
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
}
