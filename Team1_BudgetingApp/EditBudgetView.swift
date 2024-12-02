//
//  EditBudgetView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 10/19/24.
//

import SwiftUI
import FirebaseAuth

// Extension to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct EditBudgetView: View {
    @StateObject private var viewModel = BudgetViewModel()

    // Available options for earning frequency
    let earningFrequencies = ["Weekly", "Biweekly", "Monthly", "Quarterly", "Annually"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) { // Use VStack with spacing 0 to stack header and content
                // Header (Sticky)
                VStack {
                    Spacer()
                        .frame(height: 15) // Adjusted spacer height for better positioning
                    
                    ZStack {
                        // Centered Title
                        Text("Edit Budget")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        // Save Button (Trailing)
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.saveUserData()
                            }) {
                                Text("Save")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .background(Color("primaryLightPink"))
                .zIndex(1) // Ensure header stays above other content

                // Scrollable Content
                ScrollView {
                    VStack(spacing: 20) { // Adjusted spacing for better layout
                        // Monthly Income Input
                        VStack(alignment: .leading, spacing: 10) { // Reduced spacing between label and field
                            HStack {
                                Text("Your Monthly Income")
                                    .foregroundColor(Color("PrimaryBlack"))
                                    .font(.title3)
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                            
                            HStack {
                                Text("$\(viewModel.monthlyIncome)")
                                    .font(.title)
                                    .foregroundColor(Color("SecondaryBlack"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Color("secondaryYellow"))
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.top, 5)
                        }

                        // Earning Frequency as Dropdown-like Button
                        VStack(alignment: .leading, spacing: 10) { // Reduced spacing between label and field
                            HStack {
                                Text("Select Earning Frequency")
                                    .foregroundColor(Color("PrimaryBlack"))
                                    .font(.title3)
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                            
                            // Custom Button to Mimic TextField Look
                            Menu {
                                ForEach(earningFrequencies, id: \.self) { frequency in
                                    Button(action: {
                                        viewModel.earningFrequency = frequency
                                    }) {
                                        Text(frequency)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.earningFrequency)
                                        .foregroundColor(Color("SecondaryBlack"))
                                        .padding(.leading, 12)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color("primaryPink"))
                                        .padding(.trailing, 10)
                                }
                                .frame(height: 40) // Removed fixed width to allow flexibility
                                .frame(maxWidth: .infinity)
                                .background(Color("secondaryYellow"))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                .padding(.horizontal, 30)
                                .padding(.top, 5) // Reduced top padding
                            }
                        }

                        // Biweekly Income Input
                        VStack(alignment: .leading, spacing: 10) { // Reduced spacing between label and field
                            HStack {
                                Text("\(viewModel.earningFrequency) Income")
                                    .foregroundColor(Color("PrimaryBlack"))
                                    .font(.title3)
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                            
                            HStack {
                                TextField("", text: $viewModel.income)
                                    .foregroundColor(Color("SecondaryBlack"))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .background(Color("secondaryYellow"))
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            Image(systemName: "pencil")
                                                .foregroundColor(Color("primaryPink"))
                                                .padding(.trailing, 10)
                                        }
                                    )
                                    .shadow(radius: 1)
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 5) // Reduced top padding
                        }

                        // Budgeting Goals Section
                        VStack(alignment: .leading, spacing: 10) { // Reduced spacing between elements
                            HStack {
                                Text("Budgeting Goals")
                                    .foregroundColor(Color("PrimaryBlack"))
                                    .font(.title3)
                                Spacer()
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 30) // Moved top padding here for better spacing
                            .padding(.bottom, 5) // Reduced bottom padding

                            Spacer()
                                .frame(height: 1)
                            
                            // Multi-Segment Bar for Budget Goals
                            GeometryReader { geometry in
                                HStack(spacing: 0) {
                                    // Needs segment with rounded left corners
                                    Rectangle()
                                        .fill(Color("primaryPink"))
                                        .frame(width: geometry.size.width * (viewModel.needsGoal / 100), height: 50)
                                        .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                                    
                                    // Wants segment (no rounding)
                                    Rectangle()
                                        .fill(Color("wantsColor"))
                                        .frame(width: geometry.size.width * (viewModel.wantsGoal / 100), height: 50)
                                    
                                    // Savings segment with rounded right corners
                                    Rectangle()
                                        .fill(Color("savingsColor"))
                                        .frame(width: geometry.size.width * (viewModel.savingsGoal / 100), height: 50)
                                        .cornerRadius(10, corners: [.topRight, .bottomRight])
                                }
                            }
                            .frame(height: 50)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 5) // Reduced bottom padding

                            // Labels for Budget Goals
                            HStack {
                                LabelView(color: "primaryPink", label: "Needs")
                                Spacer()
                                LabelView(color: "wantsColor", label: "Wants")
                                Spacer()
                                LabelView(color: "savingsColor", label: "Savings")
                            }
                            .padding(.horizontal, 50)
                        }

                        // Sliders for Goals
                        VStack(spacing: 20) {
                            GoalSlider(label: "Needs Goals (%)", amount: "\(Int(viewModel.needsGoal))%", value: $viewModel.needsGoal, otherValues: [$viewModel.wantsGoal, $viewModel.savingsGoal])
                            GoalSlider(label: "Wants Goals (%)", amount: "\(Int(viewModel.wantsGoal))%", value: $viewModel.wantsGoal, otherValues: [$viewModel.needsGoal, $viewModel.savingsGoal])
                            GoalSlider(label: "Savings Goals (%)", amount: "\(Int(viewModel.savingsGoal))%", value: $viewModel.savingsGoal, otherValues: [$viewModel.needsGoal, $viewModel.wantsGoal])
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 20) 
                }
            }
            .navigationBarHidden(true)
        }
    }

    // Reusable Label for Goal Section
    struct LabelView: View {
        var color: String
        var label: String

        var body: some View {
            HStack {
                Circle()
                    .fill(Color(color))
                    .frame(width: 10, height: 10)
                Text(label)
                    .font(.footnote)
            }
        }
    }

    // Reusable Slider for Budget Goals
    struct GoalSlider: View {
        var label: String
        var amount: String
        @Binding var value: Double
        var otherValues: [Binding<Double>]

        private func calculateAmount() -> String {
            // Assuming monthlyIncomeAmount is dynamic or passed in
            // Here, we'll mock it for simplicity
            let monthlyIncomeAmount = 5677.00
            let incomeValue = (monthlyIncomeAmount * value) / 100
            return String(format: "$%.2f", incomeValue)
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 5) { // Reduced spacing
                // Label at the top
                Text(label)
                    .foregroundColor(Color("PrimaryBlack"))
                    .padding(.horizontal, 30)

                // Slider view
                Slider(value: Binding(
                    get: { value },
                    set: { newValue in
                        let totalOtherValues = otherValues.map { $0.wrappedValue }.reduce(0, +)
                        if totalOtherValues + newValue > 100 {
                            value = 100 - totalOtherValues
                        } else {
                            value = newValue
                        }
                    }
                ), in: 0...100, step: 1)
                .accentColor(Color("primaryPink"))
                .padding(.horizontal, 30)

                // Display percentage and calculated amount below the slider
                HStack {
                    Text("\(Int(value))% (\(calculateAmount()))")
                        .foregroundColor(Color("PrimaryBlack"))
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 15)
            }
        }
    }

    // Preview
    struct EditBudgetView_Previews: PreviewProvider {
        static var previews: some View {
            EditBudgetView()
        }
    }
}
