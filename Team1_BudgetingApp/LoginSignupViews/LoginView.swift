import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isSignedIn: Bool

    var body: some View {
        NavigationView { // Wrap everything in a NavigationView
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
                        // Handle sign-in action
                        isSignedIn = true
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
            }
        }
    }
}

#Preview {
    LoginView(isSignedIn: .constant(false))
}
