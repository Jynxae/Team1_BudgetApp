import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var paswordConfirmation: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Environment(\.presentationMode) var presentationMode // To dismiss the view

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
                    .foregroundColor(Color("primaryPink"))
                
                // Email Input
                HStack {
                    TextField("Email", text: $email)
                        .padding(.vertical, 2)
                        .padding(12)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Image(systemName: "envelope")
                        .foregroundColor(Color("primaryPink"))
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
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Image(systemName: "lock")
                        .foregroundColor(Color("primaryPink"))
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
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Image(systemName: "lock")
                        .foregroundColor(Color("primaryPink"))
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
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
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
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 30)
                .padding(.top, 12)
                
                // Create Account Button
                Button(action: {
                    Task {
                        do {
                            // Input Validation
                            guard password == paswordConfirmation else {
                                alertMessage = "Passwords do not match"
                                showAlert = true
                                return
                            }
                            guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
                                alertMessage = "Please fill in all fields"
                                showAlert = true
                                return
                            }
                            guard password.count >= 6 else {
                                alertMessage = "Password must be at least 6 characters"
                                showAlert = true
                                return
                            }
                            
                            let authResult = try await AuthenticationManager.shared.createUser(
                                email: email,
                                password: password,
                                firstName: firstName,
                                lastName: lastName
                            )
                            
                            print("User created: \(authResult.uid)")
                            presentationMode.wrappedValue.dismiss() // Go back to login view
                            
                        } catch {
                            print("Failed to create user: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color("primaryPink"))
                        .cornerRadius(20)
                        .fontWeight(.bold)
                        .font(.title3)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Unable to Create Account"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                

                Spacer()
                
                //Sign In - Using NavigationLink to go back
                Button(action: {
                    // Dismiss the current view, going back to the LoginView
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Already have an account? ")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color("primaryPink"))

            }
        }
    }
}

#Preview {
    SignupView()
}
