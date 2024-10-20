//
//  SignupView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 9/28/24.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var paswordConfirmation: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        ZStack {
            Color("secondaryYellow")
                .ignoresSafeArea()

            VStack {
                Spacer()
                    .frame(height: 60)
                
                // Piggy logo
                Image("piggyPalLogoSvg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130)
                    .padding(.bottom, 12)
                
                // Sign Up Title
                Text("Sign Up")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryPink"))
                
                // Email Input
                HStack {
                    TextField("Email", text: $email)
                        .padding(.vertical, 2)
                        .padding(12)
                    Image(systemName: "envelope")
                        .foregroundColor(Color("PrimaryPink"))
                        .padding(.trailing, 15)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Password Input
                HStack {
                    SecureField("Password", text: $password)
                        .padding(.vertical, 2)
                        .padding(12)
                    Image(systemName: "lock")
                        .foregroundColor(Color("PrimaryPink"))
                        .padding(.trailing, 15)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 30)
                .padding(.top, 15)
                
                // Confirm password
                HStack {
                    TextField("Confirm Password", text: $paswordConfirmation)
                        .padding(.vertical, 2)
                        .padding(12)
                    Image(systemName: "lock")
                        .foregroundColor(Color("PrimaryPink"))
                        .padding(.trailing, 15)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 30)
                .padding(.top, 14)
                
                // First Name
                HStack {
                    TextField("First Name", text: $firstName)
                        .padding(.vertical, 2)
                        .padding(12)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 30)
                .padding(.top, 14)
                
                // Last Name
                HStack {
                    TextField("Last Name", text: $lastName)
                        .padding(.vertical, 2)
                        .padding(12)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 30)
                .padding(.top, 12)
                
                // Create Account Button
                Button(action: {
                    // Handle Create Account action
                }) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color("PrimaryPink"))
                        .cornerRadius(20)
                        .fontWeight(.bold)
                        .font(.title3)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                

                Spacer()
                
                //Sign In
                Button(action: {
                    // Handle Sign In action
                }) {
                    Text("Already an account? ")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color("PrimaryPink"))

            }
        }
    }
}

#Preview {
    SignupView()
}
