//
//  ProfileView.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 10/19/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    var body: some View {
        VStack {
            // Header
            Spacer()
                .frame(height: 15)
            VStack {
                Text("My Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
            .background(Color("PrimaryLightPink"))

            Spacer()
                .frame(height: 50)

            // Profile Icon
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color("PrimaryPink"))
                .background(Circle().fill(Color.white))
                .padding(.top, -30)
                .padding(.bottom, 30)

            // Form Fields (Refactored to Reduce Repetition)
            LabeledFormField(label: "First Name", placeholder: "First Name", text: $firstName)
            LabeledFormField(label: "Last Name", placeholder: "Last Name", text: $lastName)
            LabeledFormField(label: "Email", placeholder: "Email", text: $email)
            LabeledFormField(label: "Phone Number", placeholder: "Phone Number", text: $phoneNumber)

            // Password Field
            LabeledPasswordField(label: "Password", placeholder: "Password", text: $password, isVisible: $isPasswordVisible)

            // Reset Password Button
            HStack {
                Spacer()
                Button(action: {
                    // Add reset password action here
                }) {
                    Text("Reset Password")
                        .font(.footnote).bold()
                        .foregroundColor(Color("PrimaryPink"))
                        .padding(.top, 5)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)

            // Logout Button
            Button(action: {
                // Add logout action here
            }) {
                Text("Logout")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 190)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color("PrimaryPink"))
                    .cornerRadius(20)
                    
            }
            .padding(.bottom, 40)

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// Reusable Component for Regular Form Fields
struct LabeledFormField: View {
    var label: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .foregroundColor(Color("GrayText"))
                Spacer()
            }
            .padding(.horizontal, 40)
            Spacer()
                .frame(height: 1)
            HStack {
                TextField(placeholder, text: $text)
                    .padding(.vertical, 2)
                    .padding(12)
                    .foregroundColor(Color("GrayText"))
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
            .padding(.horizontal, 30)
            .padding(.top, 15)
        }
    }
}

// Reusable Component for Password Fields
struct LabeledPasswordField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .foregroundColor(Color("GrayText"))
                Spacer()
            }
            .padding(.horizontal, 40)
            Spacer()
                .frame(height: 1)
            HStack {
                if isVisible {
                    TextField(placeholder, text: $text)
                        .padding(.vertical, 2)
                        .padding(12)
                } else {
                    SecureField(placeholder, text: $text)
                        .padding(.vertical, 2)
                        .padding(12)
                }
                Button(action: {
                    isVisible.toggle()
                }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(Color("PrimaryPink"))
                        .padding(.trailing, 15)
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
            .padding(.horizontal, 30)
            .padding(.top, 15)
        }
    }
}

// Preview
#Preview {
    ProfileView()
}
