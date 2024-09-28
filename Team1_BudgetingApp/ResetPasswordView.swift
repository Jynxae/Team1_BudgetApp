//
//  ResetPasswordView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 9/28/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var code: String = ""
    @State private var passwordConfirmation: String = ""
    
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
                Text("Reset Password")
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
                
                
                // Code Input
                HStack {
                    SecureField("Enter Code", text: $code)
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
                
                // Password Input
                HStack {
                    SecureField("Enter New Password", text: $password)
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
                
                // Password Confirmation Input
                HStack {
                    SecureField("Confirm New Password", text: $password)
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
                
                // Sign In Button
                Button(action: {
                    // Handle sign-in action
                }) {
                    Text("Reset")
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
                    Text("Back to")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))

            }
        }
    }
}

#Preview {
    ResetPasswordView()
}
