import SwiftUI

struct RecurringTransactionsView: View {
    @ObservedObject var viewModel: FinanceViewModel = FinanceViewModel()
    @State private var showingAddRecurringTransaction = false
    @State private var transactionToDelete: Transaction? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.gradientWhite, Color.gradientOrange]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Recurring Transactions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("primaryPink"))
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddRecurringTransaction = true
                        }) {
                            HStack {
                                Text("Add")
                                    .foregroundColor(Color.primaryPink)
                                    .fontWeight(.semibold)
                                Image(systemName: "plus.circle")
                                    .foregroundColor(Color.primaryPink)
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .sheet(isPresented: $showingAddRecurringTransaction) {
                            AddRecurringTransactionView(viewModel: viewModel)
                        }
                    }
                    .offset(y: -20)
                    .padding(.horizontal)
                                        
                    // Recurring Transactions List Section
                    VStack {
                        List {
                            ForEach(viewModel.recurringTransactions) { transaction in
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(colorForType(transaction.type))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: iconName(for: transaction.type))
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    }
                                    .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(transaction.name)
                                            .font(.headline)
                                        Text(transaction.subcategory)
                                            .font(.subheadline)
                                            .italic()
                                            .foregroundColor(.gray)
                                        if let recurrenceFrequency = transaction.recurrenceFrequency?.rawValue.capitalized {
                                            Text("Repeats \(recurrenceFrequency)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        if let nextDate = transaction.nextScheduledDate(from: transaction.date) {
                                            Text("Next Scheduled: \(formattedDate(from: nextDate))")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(String(format: "$%.2f", transaction.amount))
                                        .font(.headline)
                                        .padding(.leading, 2)
                                }
                                .padding(.vertical, 8)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        transactionToDelete = transaction
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        
                        Spacer()
                    }
                }
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color.gradientWhite, Color.gradientOrange]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .alert(item: $transactionToDelete) { transaction in
                    Alert(
                        title: Text("Delete Transaction"),
                        message: Text("Are you sure you want to delete \"\(transaction.name)\"?"),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteTransaction(transaction)
                        },
                        secondaryButton: .cancel {
                            transactionToDelete = nil
                        }
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchTransactions()
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // You can use .short, .medium, .long, or .full
        return formatter
    }()
    
    func formattedDate(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
