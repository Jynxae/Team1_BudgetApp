import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var code: String = ""
    @State private var resetMessage: String?
    @State private var passwordConfirmation: String = ""
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
                
                // Sign In Title
                Text("Reset Password")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primaryPink"))
                
                // Email Input
                HStack {
                    TextField("Email", text: $email)
                        .padding(.vertical, 2)
                        .padding(12)
                        .autocapitalization(.none)
                    Image(systemName: "envelope")
                        .foregroundColor(Color("primaryPink"))
                        .padding(.trailing, 15)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Reset Button
                Button(action: {
                    Task {
                        do {
                            try await AuthenticationManager.shared.sendPasswordReset(email: email)
                            print("Password reset email sent!")
                            resetMessage = "Password reset email sent!"
//                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            resetMessage = "Error sending password reset email."
                            print("Error sending password reset email: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Reset Password")
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
                
                // Display reset confirmation message
                if let resetMessage = resetMessage {
                    Text(resetMessage)
                        .foregroundColor(.blue)
                        .font(.callout)
                        .padding(.top, 8)
                }

                Spacer()
                
                // Back to Sign In
                Button(action: {
                    // Dismiss ResetPasswordView and go back to LoginView
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back to")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color("primaryPink"))

            }
        }
    }
}

#Preview {
    ResetPasswordView()
}
