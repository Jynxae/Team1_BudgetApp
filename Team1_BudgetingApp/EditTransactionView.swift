import SwiftUI

struct EditTransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: FinanceViewModel

    let transactionId: UUID

    // Input Fields
    @State private var name: String
    @State private var type: TransactionType
    @State private var subcategory: String
    @State private var date: Date
    @State private var notes: String
    @State private var amount: String
    @State private var isExpanded: Bool = false

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

    // Custom initializer with Transaction ID and initial data
    init(viewModel: FinanceViewModel, transactionId: UUID) {
        self.viewModel = viewModel
        self.transactionId = transactionId // This assigns the parameter to the instance property

        // Retrieve the transaction from the view model using the ID
        if let transaction = viewModel.transactions.first(where: { $0.id == transactionId }) {
            _name = State(initialValue: transaction.name)
            _type = State(initialValue: transaction.type)
            _subcategory = State(initialValue: transaction.subcategory)
            _date = State(initialValue: transaction.date)
            _notes = State(initialValue: transaction.notes)
            _amount = State(initialValue: String(transaction.amount))
        } else {
            // Provide default values if the transaction is not found
            _name = State(initialValue: "")
            _type = State(initialValue: .need)
            _subcategory = State(initialValue: "")
            _date = State(initialValue: Date())
            _notes = State(initialValue: "")
            _amount = State(initialValue: "0")
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
                    Spacer()
                    
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
                    VStack() {
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
                                        print("\(transactionType) selected")
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
                                .frame(maxWidth: 315, maxHeight: 150) // Adjust maxWidth to align with button
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 1)
                                .padding(.top, 10) // Adds some space between button and dropdown
                            }
                            .transition(.opacity)
                        }
                    }
                    
                    // Transaction Date
                    HStack {
                        DatePicker(selection: $date, displayedComponents: .date) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.primaryPink)
                                    .padding(.top, 1)
                                Text("Transaction Date: ")
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
                    
                    // Add Notes
                    VStack {
                        ZStack(alignment: .topLeading) {
                            
                            // Placeholder text
                            TextEditor(text: self.$notes)
                                .foregroundColor(self.notes == "Enter your note here..." ? .gray : .primary)
                                .cornerRadius(12)
                                .padding()
                                .onAppear {
                                    // remove the placeholder text when keyboard appears
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                                        withAnimation {
                                            if self.notes == "Enter your note here..." {
                                                self.notes = ""
                                            }
                                        }
                                    }
                                    
                                    // put back the placeholder text if the user dismisses the keyboard without adding any text
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                                        withAnimation {
                                            if self.notes == "" {
                                                self.notes = "Enter your note here..."
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: 345, maxHeight: 150)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 1)
                    )

                    // Save Changes Button
                    Button(action: {
                        saveTransaction()
                    }) {
                        Text("Save Changes")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.primaryPink)
                            .cornerRadius(20)
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                }
                .navigationTitle("Edit Transaction")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Edit Transaction")
                            .foregroundColor(Color.primaryPink)
                            .fontWeight(.bold)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveTransaction()
                        }
                        .disabled(!isFormValid)
                    }
                }
            }
        }
    }

    // Function to Save Edited Transaction
    private func saveTransaction() {
        guard let amountDouble = Double(amount) else { return }

        // Find the transaction in the view model using its ID and update it directly
        if let index = viewModel.transactions.firstIndex(where: { $0.id == transactionId }) {
            viewModel.transactions[index].name = name.trimmingCharacters(in: .whitespaces)
            viewModel.transactions[index].type = type
            viewModel.transactions[index].subcategory = subcategory
            viewModel.transactions[index].date = date
            viewModel.transactions[index].notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.transactions[index].amount = amountDouble
        }

        // Recalculate the totals if necessary
        viewModel.recalculateTotals()
        presentationMode.wrappedValue.dismiss()
    }

    // Validation for Form
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !subcategory.isEmpty &&
        Double(amount) != nil &&
        Double(amount)! > 0
    }
}


