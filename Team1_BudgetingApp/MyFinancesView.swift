import SwiftUI

struct MyFinancesView: View {
    
    @StateObject private var viewModel = FinanceViewModel()
    @State private var showingAddTransaction = false // State to control sheet presentation
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.gradientWhite, Color.gradientOrange]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
                        
            NavigationStack {
                VStack(spacing: 0) {
                    MyFinancesHeaderView()
                    // Progress Section
                    VStack {
                        Text("Your Current Progress")
                            .font(.headline)
                            .foregroundColor(Color.primaryPink)
                            .padding(.top)
                        
                        HStack {
                            // Custom progress bar sections with dynamic percentages
                            ProgressBar(
                                needsPercentage: viewModel.needsPercentage,
                                wantsPercentage: viewModel.wantsPercentage,
                                savingsPercentage: viewModel.savingsPercentage,
                                remainingIncomePercentage: viewModel.remainingIncomePercentage
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primaryPink, lineWidth: 1)
                            )
                    )
                    .cornerRadius(12)
                    .padding()
                    
                    // Transactions List Section
                    VStack {
                        HStack {
                            transactionDateNav
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddTransaction = true
                            }) {
                                HStack {
                                    Text("Add Transaction")
                                        .foregroundColor(Color.primaryPink)
                                        .fontWeight(.semibold)
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(Color.primaryPink)
                                        .fontWeight(.semibold)
                                }
                            }
                            .sheet(isPresented: $showingAddTransaction) {
                                                            AddTransactionView(viewModel: viewModel)
                                                        }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        List {
                            ForEach(transactionRows) { transaction in
                                NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                                    TransactionRow(transaction: transaction)
                                }
                            }
                        }
//                        .listStyle(PlainListStyle()) // Optional: Adjust list style
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                    // Transactions List
                }
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color.gradientWhite, Color.gradientOrange]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(Color.clear)
        }
    }
    
    var transactionDateNav: some View {
        HStack {
           Button(action: {
               viewModel.moveToPreviousDay()
           }) {
               Image(systemName: "chevron.left")
                   .foregroundColor(.primary)
           }
           
           Text(viewModel.dateString(for: viewModel.selectedDate))
               .font(.headline)
               .foregroundColor(.primary)
                  
           Button(action: {
               viewModel.moveToNextDay()
           }) {
               Image(systemName: "chevron.right")
                   .foregroundColor(viewModel.isFutureDate ? .gray : .primary)
           }
           .disabled(viewModel.isFutureDate)
       }
    }
}

struct ProgressBar: View {
    
    var needsPercentage: CGFloat
    var wantsPercentage: CGFloat
    var savingsPercentage: CGFloat
    var remainingIncomePercentage: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    // Needs Segment
                    Rectangle()
                        .fill(Color.needs)
                        .frame(width: needsPercentage * geometry.size.width, height: 60)
                    
                    // Wants Segment
                    Rectangle()
                        .fill(Color.wants)
                        .frame(width: wantsPercentage * geometry.size.width, height: 60)
                    
                    // Savings Segment
                    Rectangle()
                        .fill(Color.savings)
                        .frame(width: savingsPercentage * geometry.size.width, height: 60)
                    
                    // Remaining Income Segment
                    Rectangle()
                        .fill(Color.remainingIncome)
                        .frame(width: remainingIncomePercentage * geometry.size.width, height: 60)
                }
                .cornerRadius(10)
                
                HStack {
                    HStack {
                        Circle()
                            .fill(Color.needs)
                            .frame(width: 10, height: 10)
                        Text("Needs")
                            .font(.caption)
                    }
                    
                    HStack {
                        Circle()
                            .fill(Color.wants)
                            .frame(width: 10, height: 10)
                        Text("Wants")
                            .font(.caption)
                    }
                    
                    HStack {
                        Circle()
                            .fill(Color.savings)
                            .frame(width: 10, height: 10)
                        Text("Savings")
                            .font(.caption)
                    }
                    
                    HStack {
                        Circle()
                            .fill(Color.remainingIncome)
                            .frame(width: 10, height: 10)
                        Text("Remaining Income")
                            .font(.caption)
                    }
                    
                }
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
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
            }
            Spacer()
            Text(String(format: "$%.2f", transaction.amount))
                .font(.headline)
                .padding(.leading, 2)
        }
        .padding(.vertical, 8)
    }
}

struct MyFinancesHeaderView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 15)
            Text("My Finances")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 8)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.primaryLightPink))
    }
}

struct FinanceView_Previews: PreviewProvider {
    static var previews: some View {
        MyFinancesView()
    }
}