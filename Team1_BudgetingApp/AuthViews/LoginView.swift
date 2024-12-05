import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isSignedIn: Bool
    @State private var errorMessage: String? // To display error messages
    @State private var showWelcomeView: Bool = false // Tracks if WelcomeView should be shown
    @ObservedObject var financeViewModel: FinanceViewModel

    var body: some View {
            NavigationStack {
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

                        // Sign In Title
                        Text("Sign In")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("primaryPink"))

                        // Email Input
                        HStack {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(.vertical, 2)
                                .padding(12)
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
                            Image(systemName: "lock")
                                .foregroundColor(Color("primaryPink"))
                                .padding(.trailing, 15)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 1)
                        .padding(.horizontal, 30)
                        .padding(.top, 15)

                        // Sign In Button
                        Button(action: {
                            Task {
                                await signInUser()
                            }
                        }) {
                            Text("Sign in")
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

                        // Display error message
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.callout)
                                .padding(.top, 10)
                        }

                        // Forgot Password - Using NavigationLink
                        NavigationLink(destination: ResetPasswordView()) {
                            Text("Forgot Password?")
                                .foregroundColor(Color("primaryPink"))
                                .fontWeight(.semibold)
                                .font(.callout)
                        }

                        Spacer()

                        // Sign up using NavigationLink
                        NavigationLink(destination: SignupView()) {
                            Text("Don’t have an account?")
                            Text("Sign Up")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(Color("primaryPink"))
                    }
                    .navigationDestination(isPresented: $showWelcomeView) {
                        WelcomeView(financeViewModel: financeViewModel, isSignedIn: $isSignedIn)
                    }
                }
            }
        }

        private func signInUser() async {
            do {
                // Sign in using Firebase Authentication
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                print("User signed in: \(authResult.user.uid)")

                // Check if the user exists in Firestore
                let db = Firestore.firestore()
                let document = try await db.collection("users").document(authResult.user.uid).getDocument()

                // Check if the user's budget exists in the user_budget subcollection
                if document.exists && document.data()?["user_budget"] == nil {
                    // No income data found, show WelcomeView
                    showWelcomeView = true
                    return
                }
                
                if document.exists {
                    // User has income data, proceed to the main app
                    isSignedIn = true
                }
                
            } catch {
                print("Failed to sign in: \(error.localizedDescription)")
                errorMessage = "Failed to sign in. Please try again."
            }
        }
}

//#Preview {
//    LoginView(isSignedIn: .constant(false))
//}
