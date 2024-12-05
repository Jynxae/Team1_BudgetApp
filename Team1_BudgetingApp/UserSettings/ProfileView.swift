import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var alertMainMessage: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isSaving = false
    @State private var showChangeEmailSheet = false
    @State private var newEmail = ""
    @State private var isPasswordVisible = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                // Profile Icon
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color("primaryPink"))
                    .background(Circle().fill(Color.white))
                    .padding(.top, -30)
                    .padding(.bottom, 30)

                // Form Fields (Refactored to Reduce Repetition)
                LabeledFormField(label: "First Name", placeholder: "First Name", text: $viewModel.firstName)
                LabeledFormField(label: "Last Name", placeholder: "Last Name", text: $viewModel.lastName)
                LabeledFormField(label: "Phone Number", placeholder: "Phone Number", text: $viewModel.phoneNumber)
                LabeledFormField(label: "Email", placeholder: "Email", text: $viewModel.email)
                    .disabled(true)
                
                // Change Email Button
                HStack {
                    Spacer() // Pushes the button to the right
                    Button(action: {
                        showChangeEmailSheet = true // Show the sheet for entering new email
                    }) {
                        Text("Change Email")
                            .font(.footnote).bold()
                            .foregroundColor(Color("primaryPink"))
                            .padding(.top, 5)
                    }
                }
                .sheet(isPresented: $showChangeEmailSheet) {
                    VStack {
                        Text("Change Email Request")
                            .foregroundColor(Color("primaryPink"))
                            .font(.title)
                            .bold()
                            .padding(.bottom, 30)
                        
                        VStack {
                            LabeledFormField(label: "Enter New Email", placeholder: "New Email", text: $newEmail)
                            LabeledPasswordField(label: "Confirm Password", placeholder: "Password", text: $password, isVisible: $isPasswordVisible)
                        }
                        .padding(.bottom, 20)
                       
                        Button("Submit") {
                            Task {
                                do {
                                    try await viewModel.changeEmail(newEmail: newEmail, password: password)
                                    alertMessage = "A verification link has been sent to \(newEmail). Please verify to complete the email change."
                                    alertMainMessage = "Email Change Request"
                                } catch {
                                    alertMessage = "Failed to change email: \(error.localizedDescription)"
                                    alertMainMessage = "Error"
                                }
                                showAlert = true
                                showChangeEmailSheet = false
                            }
                        }
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 50)
                        .padding()
                        .background(Color("primaryPink"))
                        .cornerRadius(20)

                        Button("Cancel") {
                            showChangeEmailSheet = false
                        }
                        .padding(.top)
                    }
                    .padding()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(alertMainMessage),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(.horizontal, 30)
                // Password Field
                LabeledPasswordField(label: "Password", placeholder: "Password", text: $viewModel.password, isVisible: $isPasswordVisible)
                    .disabled(true)

                // Reset Password Button
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                try await AuthenticationManager.shared.sendPasswordReset(email: viewModel.email)
                                print("Password reset email sent!")
                                alertMessage = "Password reset link sent to email!"
                                alertMainMessage = "Password Reset"
                                showAlert = true
    //                            presentationMode.wrappedValue.dismiss()
                            } catch {
                                alertMessage = "Error sending password reset email."
                                alertMainMessage = "Password Reset"
                                showAlert = true
                                print("Error sending password reset email: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text("Reset Password")
                            .font(.footnote).bold()
                            .foregroundColor(Color("primaryPink"))
                            .padding(.top, 5)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(alertMainMessage),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)

                // Save Button (Bottom of the Screen)
                Button(action: {
                    Task {
                        isSaving = true
                        await viewModel.saveUserData()
                        settingsViewModel.fetchUserName()
                        isSaving = false
                    }
                }) {
                    if isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 190, height: 44)
                    } else {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color("primaryPink"))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                await viewModel.loadUserData()
            }
        }
    }
}

// Reusable Component for Regular Form Fields
struct LabeledFormField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    @Environment(\.isEnabled) private var isEnabled // Automatically reflects the .disabled state

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
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.vertical, 2)
                    .padding(12)
                    .foregroundColor(Color("GrayText"))
                    .foregroundColor(isEnabled ? .primary : .gray)
                    .background(isEnabled ? Color.white : Color.gray.opacity(0.2))
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
            .padding(.horizontal, 30)
            .padding(.top, 8)
        }
    }
}

// Reusable Component for Password Fields
struct LabeledPasswordField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    @Environment(\.isEnabled) private var isEnabled // Automatically reflects the .disabled state

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
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.vertical, 2)
                        .padding(12)
                        .foregroundColor(isEnabled ? .primary : .gray)
                        .background(isEnabled ? Color.white : Color.gray.opacity(0.2))
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
            .padding(.horizontal, 30)
            .padding(.top, 8)
        }
    }
}

// Preview
#Preview {
    ProfileView()
}
