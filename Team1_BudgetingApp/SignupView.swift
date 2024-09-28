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
            Color(red: 255/255, green: 242/255, blue: 227/255)
                .ignoresSafeArea()

            VStack {
                Spacer()
                    .frame(height: 60)
                
                // Piggy logo
                Image("Piggy_logo_signin")
                    .padding(.bottom, 12)
                
                // Sign In Title
                Text("Sign Up")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))
                
                // Email Input
                HStack {
                    TextField("Email", text: $email)
                        .padding(.vertical, 2)
                        .padding(12)
                    Image(systemName: "envelope")
                        .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))
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
                        .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))
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
                        .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))
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
                
                // Sign In Button
                Button(action: {
                    // Handle sign-in action
                }) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(red: 255/255, green: 158/255, blue: 182/255))
                        .cornerRadius(20)
                        .fontWeight(.bold)
                        .font(.title3)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                

                Spacer()
                
                //Sign up
                Button(action: {
                    // Handle Sign Up action
                }) {
                    Text("Already an account? ")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))

            }
        }
    }
}

#Preview {
    SignupView()
}
