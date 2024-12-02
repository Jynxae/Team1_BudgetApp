//
//  BudgetViewModel.swift
//  Team1_BudgetingApp
//
//  Created by Sue on 12/1/24.
//

import Foundation
import Combine
import FirebaseFirestore

class BudgetViewModel: ObservableObject {
    @Published var monthlyIncome: String = "0.00" // calculated based off of earning freq and income
    @Published var earningFrequency: String = ""
    @Published var income: String = "0.00"
    @Published var needsGoal: Double = 50
    @Published var wantsGoal: Double = 30
    @Published var savingsGoal: Double = 20

    let db = Firestore.firestore()

    func fetchBudgetData(forUser userId: String) {
        // Firestore document reference: users/{userId}
        let userDocRef = db.collection("users").document(userId)

        userDocRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()

                // Parse Firestore data into ViewModel properties
                if let incomeFreq = data?["income_freq"] as? String {
                    self.earningFrequency = incomeFreq
                }
                
                if let income = data?["income"] as? Double {
                    self.income = String(format: "$%.2f", income)
                }

                if let needs = data?["budget_needs_perc"] as? Double {
                    self.needsGoal = needs
                }

                if let wants = data?["budget_wants_perc"] as? Double {
                    self.wantsGoal = wants
                }

                if let savings = data?["budget_savings_perc"] as? Double {
                    self.savingsGoal = savings
                }

                self.calculateMonthlyIncome()
            } else {
                print("Document does not exist")
            }
        }
    }

    private func calculateMonthlyIncome() {
        let income = Double(income.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0

        switch earningFrequency.lowercased() {
        case "weekly":
            monthlyIncome = String(format: "%.2f", income * 4.0)
        case "biweekly":
            monthlyIncome = String(format: "%.2f", income * 2.0)
        case "monthly":
            monthlyIncome = String(format: "%.2f", income)
        case "quarterly":
            monthlyIncome = String(format: "%.2f", income / 3.0)
        case "annually":
            monthlyIncome = String(format: "%.2f", income / 12.0)
        default:
            monthlyIncome = "0.00"
        }
    }
}
