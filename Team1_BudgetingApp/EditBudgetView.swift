//
//  EditBudgetView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 10/19/24.
//

import SwiftUI

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
    @State private var monthlyIncome: String = "$5,677.00"
    @State private var earningFrequency: String = "Biweekly"
    @State private var biweeklyIncome: String = "$2,838.50"
    @State private var needsGoal: Double = 50
    @State private var wantsGoal: Double = 30
    @State private var savingsGoal: Double = 20

    // Available options for earning frequency
    let earningFrequencies = ["Weekly", "Biweekly", "Semimonthly", "Monthly", "Quarterly", "Annually"]

    var body: some View {
            VStack {
                // Header with title
                VStack{
                    Spacer()
                        .frame(height: 70)
                    Text("Edit Budget")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color("primaryLightPink"))

                Spacer()
                    .frame(height: 30)
                
                ScrollView {
                    // Monthly Income Input
                    VStack {
                        HStack {
                            Text("Your Monthly Income")
                                .foregroundColor(Color("PrimaryBlack"))
                                .font(.title3)
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                            .frame(height: 1)
                        HStack {
                            TextField("", text: $monthlyIncome)
                                .font(.title)
                                .foregroundColor(Color("SecondaryBlack"))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .background(Color("secondaryYellow"))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity)
                                .shadow(radius: 1)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 15)
                    }
                    
                    Spacer()
                        .frame(height: 35)

                    // Earning Frequency as Dropdown-like Button
                    VStack {
                        HStack {
                            Text("Select Earning Frequency")
                                .foregroundColor(Color("PrimaryBlack"))
                                .font(.title3)
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        .frame(height: 1)
                        
                        // Custom Button to Mimic TextField Look
                        Menu {
                            ForEach(earningFrequencies, id: \.self) { frequency in
                                Button(action: {
                                    earningFrequency = frequency
                                }) {
                                    Text(frequency)
                                }
                            }
                        } label: {
                            HStack {
                                Text(earningFrequency)
                                    .foregroundColor(Color("SecondaryBlack"))
                                    .padding(.leading, 12)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color("primaryPink"))
                                    .padding(.trailing, 10)
                            }
                            .frame(width: 340, height: 40) // Fixed width and height for the frame
                            .background(Color("secondaryYellow")) // Extend the background color
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.horizontal, 30)
                            .padding(.top, 15)
                        }
                    }

                    
                    Spacer()
                        .frame(height: 25)

                    // Biweekly Income Input
                    VStack {
                        HStack {
                            Text("\(earningFrequency) Income")
                                .foregroundColor(Color("PrimaryBlack"))
                                .font(.title3)
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                            .frame(height: 1)
                        HStack {
                            TextField("", text: $biweeklyIncome)
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
                        .padding(.top, 15)
                    }

                    // Budgeting Goals Section
                    VStack {
                        HStack {
                            Text("Budgeting Goals")
                                .foregroundColor(Color("PrimaryBlack"))
                                .font(.title3)
                                .padding(.top, 30)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        .padding(.horizontal, 30)

                        Spacer()
                            .frame(height: 1)
                        
                        // Multi-Segment Bar for Budget Goals
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                // Needs segment with rounded left corners
                                Rectangle()
                                    .fill(Color("primaryPink"))
                                    .frame(width: geometry.size.width * (needsGoal / 100), height: 50)
                                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                                
                                // Wants segment (no rounding)
                                Rectangle()
                                    .fill(Color("wantsColor"))
                                    .frame(width: geometry.size.width * (wantsGoal / 100), height: 50)
                                
                                // Savings segment with rounded right corners
                                Rectangle()
                                    .fill(Color("savingsColor"))
                                    .frame(width: geometry.size.width * (savingsGoal / 100), height: 50)
                                    .cornerRadius(10, corners: [.topRight, .bottomRight])
                            }
                        }
                        .frame(height: 50) // Set the height for the bar
                        .padding(.horizontal, 30)
                        .padding(.bottom, 10)


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
                    VStack {
                        GoalSlider(label: "Needs Goals (%)", amount: "\(Int(needsGoal))%", value: $needsGoal, otherValues: [$wantsGoal, $savingsGoal])
                        GoalSlider(label: "Wants Goals (%)", amount: "\(Int(wantsGoal))%", value: $wantsGoal, otherValues: [$needsGoal, $savingsGoal])
                        GoalSlider(label: "Savings Goals (%)", amount: "\(Int(savingsGoal))%", value: $savingsGoal, otherValues: [$needsGoal, $wantsGoal])
                    }

                    Spacer()
                        .frame(height: 30)
                }
            }
        
        .edgesIgnoringSafeArea(.top)
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
    @State private var monthlyIncomeAmount: Double = 5677.00 // Example monthly income

    private func calculateAmount() -> String {
        let incomeValue = (monthlyIncomeAmount * value) / 100
        return String(format: "$%.2f", incomeValue)
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Label at the top
            Text(label)
                .foregroundColor(Color("PrimaryBlack"))
                .padding(.top, 5)
                .padding(.horizontal, 30)
            
            Spacer()
                .frame(height: 1)
            
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
            
            Spacer()
                .frame(height: 1)
            
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
#Preview {
    EditBudgetView()
}
