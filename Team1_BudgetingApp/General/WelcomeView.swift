//
//  WelcomeView.swift
//  Team1_BudgetingApp
//
//  Created by Sue on 12/1/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct WelcomeView: View {
    @StateObject private var budgetViewModel = BudgetViewModel() // Create ViewModel instance
    @State private var isLoading = true
    @State private var hasCompletedOnboarding = false
    @Binding var isSignedIn: Bool

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .onAppear {
                        loadUserData()
                }
            } else {
                // Onboarding appears
                OnboardingCarouselView(
                    hasCompletedOnboarding: $hasCompletedOnboarding,
                    budgetViewModel: budgetViewModel,
                    isSignedIn: $isSignedIn
                )
            }
        }
        .animation(.easeInOut, value: hasCompletedOnboarding)
    }

    func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }

        // Fetch user data using BudgetViewModel
        budgetViewModel.fetchBudgetData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hasCompletedOnboarding = !budgetViewModel.earningFrequency.isEmpty
            isLoading = false
        }
    }
}

struct OnboardingCarouselView: View {
    @Binding var hasCompletedOnboarding: Bool
    @ObservedObject var budgetViewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss // Used to close the WelcomeView

    @State private var inputIncome: String = ""
    @State private var selectedFrequency: String = "Monthly"
    @State private var currentTab = 0
    
    @Binding var isSignedIn: Bool

    let frequencies = ["Weekly", "Biweekly", "Monthly", "Quarterly", "Annually"]
    let totalTabs = 3

    var body: some View {
        VStack {
            TabView(selection: $currentTab) {
                // Slide 1: Welcome Screen
                VStack {
                    Spacer()
                    Image("piggyPalLogoSvg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180)
                        .padding(.bottom, 20)
                    Text("Welcome to PiggyPal!")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("primaryPink"))
                        .padding(.bottom, 10)
                    Text("Let's set up your profile by adding your income details and setting budgeting goals!")
                        .font(.system(size: 20))
                        .foregroundColor(Color("SecondaryBlack"))
                        .multilineTextAlignment(.center)
                        .padding([.trailing, .leading])
                    Spacer()
                }
                .tag(0)

                // Slide 2: Income Input & Frequency
                VStack {
                    Spacer()
                    Image("moneyIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180)
                        .padding(.bottom, 20)
                    Text("Step 1: Enter Your Income Details")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("primaryPink"))
                        .padding(.bottom, 20)

                    VStack {
                        Text("Enter Your Income")
                            .font(.body)
                            .foregroundColor(Color("SecondaryBlack"))

                        TextField("Enter your income", text: $inputIncome)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                            .padding()
                    }

                    VStack {
                        Text("Select Your Income Frequency")
                            .font(.body)
                            .foregroundColor(Color("SecondaryBlack"))

                        Menu {
                            ForEach(frequencies, id: \.self) { frequency in
                                Button(action: {
                                    selectedFrequency = frequency
                                }) {
                                    Text(frequency)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedFrequency)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 10)
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                .tag(1)

                // Slide 3: Set Budgeting Goals
                VStack {
                    Spacer()
                    Image("targetIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180)
                        .padding(.bottom, 20)
                    Text("Step 2: Set Your Budgeting Goals")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("primaryPink"))
                        .padding(.bottom, 20)

                    VStack(alignment: .leading, spacing: 20) {
                        BudgetInputField(label: "Needs Goal (%)", value: $budgetViewModel.needsGoal)
                        BudgetInputField(label: "Wants Goal (%)", value: $budgetViewModel.wantsGoal)
                        BudgetInputField(label: "Savings Goal (%)", value: $budgetViewModel.savingsGoal)
                    }
                    .padding(.horizontal)

                    Text("Total: \(Int(totalPercentage()))%")
                        .font(.headline)
                        .foregroundColor(totalPercentage() > 100 ? .red : .green)
                        .padding(.top)

                    Spacer()
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding()

            // Carousel Dots
            HStack(spacing: 8) {
                ForEach(0..<totalTabs, id: \.self) { index in
                    Circle()
                        .fill(currentTab == index ? Color("primaryPink") : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 20)

            // Navigation Buttons
            HStack {
                Button(action: {
                    if currentTab > 0 {
                        currentTab -= 1
                    }
                }) {
                    Text("Back")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("primaryPink").opacity(0.2))
                        .cornerRadius(8)
                }
                .disabled(currentTab == 0)
                
                if (currentTab < totalTabs - 1) {
                    Button(action: {
                        if currentTab < totalTabs - 1 {
                            currentTab += 1
                        }
                    }) {
                        Text("Next")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(currentTab == 1 && inputIncome.isEmpty ? Color.gray : Color("primaryPink"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(currentTab == 1 && inputIncome.isEmpty)
                }
                
                else {
                    Button(action: {
                        if allFieldsValid() {
                            saveUserData()
                            dismiss()
                        }
                    }) {
                        Text("Finish")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(allFieldsValid() ? Color("primaryPink") : .gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(!allFieldsValid())
                }
            }
            .padding()
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }

    private func totalPercentage() -> Double {
        return budgetViewModel.needsGoal + budgetViewModel.wantsGoal + budgetViewModel.savingsGoal
    }

    private func allFieldsValid() -> Bool {
        // Ensure all fields are filled out and the total percentage is valid
        return !inputIncome.isEmpty &&
            !selectedFrequency.isEmpty &&
            totalPercentage() <= 100 &&
            totalPercentage() > 0
    }

    func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }

        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .setData([
                "user_budget": [
                    "income": Double(inputIncome) ?? 0.0,
                    "income_freq": selectedFrequency,
                    "budget_needs_perc": budgetViewModel.needsGoal,
                    "budget_wants_perc": budgetViewModel.wantsGoal,
                    "budget_savings_perc": budgetViewModel.savingsGoal
                ]
            ], merge: true) { error in
                if let error = error {
                    print("Error saving data: \(error.localizedDescription)")
                } else {
                    print("User budget data saved successfully!")
                    hasCompletedOnboarding = true
                    isSignedIn = true
                }
            }
    }

}

struct BudgetInputField: View {
    var label: String
    @Binding var value: Double

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)

            Spacer()

            TextField("Enter \(label.lowercased())", value: $value, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 80)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(isSignedIn: .constant(false))
    }
}
