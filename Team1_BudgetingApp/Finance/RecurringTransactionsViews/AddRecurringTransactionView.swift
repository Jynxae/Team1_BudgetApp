//
//  AddRecurringTransactionView.swift
//  Team1_BudgetingApp
//
//  Created by Sue on 12/4/24.
//


import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth

struct AddRecurringTransactionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: FinanceViewModel
    
    // Input Fields
    @State private var name: String = ""
    @State private var type: TransactionType = .need
    @State private var subcategory: String = ""
    @State private var date: Date = Date()
    @State private var notes: String = "Enter your note here..."
    @State private var amount: String = ""
    @State private var isExpanded: Bool = false
    
    // Recurring Transaction
    @State private var recurrenceFrequency: RecurrenceFrequency = .monthly
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // Subcategories based on Transaction Type
    var subcategories: [String] {
        switch type {
        case .need:
            return ["Groceries", "Utilities", "Rent", "Transportation", "Healthcare", "Other"]
        case .want:
            return ["Dining Out", "Entertainment", "Shopping", "Travel", "Hobbies", "Other"]
        case .savings:
            return ["Emergency Fund", "Retirement", "Investments", "Other"]
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.gradientWhite, Color.gradientOrange]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 15) {                    
                    // Transaction Name
                    VStack {
                        TextField("Transaction Name", text: $name)
                            .padding(.vertical, 2)
                            .padding(12)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .frame(maxWidth: 345)
                    
                    // Transaction Type
                    VStack {
                        Text("Category")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primaryPink)
                        
                        HStack(spacing: 40) {
                            ForEach(TransactionType.allCases, id: \.self) { transactionType in
                                VStack {
                                    Button(action: {
                                        type = transactionType
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(type == transactionType ? colorForType(transactionType) : .white)
                                                .frame(width: 70, height: 70)
                                                .shadow(radius: 1)
                                            
                                            Image(systemName: iconName(for: transactionType))
                                                .foregroundColor(type == transactionType ? .white : .secondary)
                                                .font(.system(size: 34))
                                        }
                                    }
                                    Text("\(transactionType.rawValue)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: 345, maxHeight: 160)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 1)
                    )
                    
                    // Transaction Subcategory
                    ZStack(alignment: .top) {
                        VStack {
                            Text("Subcategory")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.primaryPink)
                            
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }) {
                                HStack {
                                    Text(subcategory.isEmpty ? "Choose subcategory..." : subcategory)
                                        .foregroundColor(subcategory.isEmpty ? .secondary : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                        .animation(.easeInOut, value: isExpanded)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                            }
                            .foregroundColor(Color.primaryPink)
                            .zIndex(1) // Ensures the button stays above the dropdown
                        }
                        .padding()
                        .frame(maxWidth: 345)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(radius: 1)
                        )
                        
                        // Dropdown content
                        if isExpanded {
                            VStack {
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(subcategories, id: \.self) { sub in
                                            Text(sub)
                                                .padding()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(subcategory == sub ? Color.primaryPink.opacity(0.2) : Color.white)
                                                .onTapGesture {
                                                    subcategory = sub
                                                    withAnimation {
                                                        isExpanded = false
                                                    }
                                                }
                                        }
                                    }
                                }
                                .frame(maxWidth: 315, maxHeight: 150)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                                .padding(.top, 10)
                            }
                            .transition(.opacity)
                        }
                    }
                    
                    // Add Amount
                    VStack {
                        HStack {
                            Image(systemName: "dollarsign")
                                .padding(.leading)
                                .foregroundColor(Color.primaryPink)
                            TextField("Amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .onReceive(amount.publisher.collect()) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        self.amount = String(filtered)
                                    }
                                }
                                .padding(.vertical, 2)
                                .padding(12)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .frame(maxWidth: 345)
                    
                    // Transaction Date
                    HStack {
                        DatePicker(selection: $date, displayedComponents: .date) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.primaryPink)
                                    .padding(.top, 1)
                                Text("Starting on: ")
                                    .foregroundColor(Color.primaryPink)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: 345)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 1)
                    )
                    
                    // Recurrence Frequency
                    VStack {
                        Text("Recurrence Frequency")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primaryPink)
                            .padding(.leading, 15)
                            .padding(.top, 10)
                        
                        Picker("Frequency", selection: $recurrenceFrequency) {
                            ForEach(RecurrenceFrequency.allCases, id: \.self) { frequency in
                                Text(frequency.rawValue.capitalized)
                                    .tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    .frame(maxWidth: 345)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 1)
                    )
                }
                .navigationTitle("Add Recurring Transaction")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Add Recurring Transaction")
                            .foregroundColor(Color.primaryPink)
                            .fontWeight(.bold)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            handleAddTransaction()
                        }
                        .disabled(!isFormValid)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Unable to Add Transaction"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    private func handleAddTransaction() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            alertMessage = "Invalid amount."
            showAlert = true
            return
        }
        
        if amountValue > viewModel.remainingIncome {
            alertMessage = "Amount exceeds remaining income! Please adjust transaction amount or update income."
            showAlert = true
            return
        }
        
        let newTransaction = Transaction(
            name: name,
            type: type,
            subcategory: subcategory,
            date: date,
            notes: notes,
            amount: amountValue,
            isRecurring: true,
            recurrenceFrequency: recurrenceFrequency
        )
        
        viewModel.addTransaction(newTransaction)
        presentationMode.wrappedValue.dismiss()
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !subcategory.isEmpty &&
        Double(amount) != nil &&
        Double(amount)! > 0
    }
}
