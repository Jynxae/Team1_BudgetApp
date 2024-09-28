import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""

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
                Text("Sign In")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))
                
                // Email Input with Icon
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
                
                // Password Input with Icon
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
                
                // Sign In Button
                Button(action: {
                    // Handle sign-in action
                }) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(red: 255/255, green: 158/255, blue: 182/255))
                        .cornerRadius(20)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                //Forgot Password
                Button(action: {
                    // Handle Forgot password action
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))
                        .fontWeight(.semibold)
                        .font(.callout)
                }

                Spacer()
                
                //Sign up
                Button(action: {
                    // Handle Sign Up action
                }) {
                    Text("Don’t have an account? ")
                    Text("Sign Up")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(red: 255/255, green: 158/255, blue: 182/255))

            }
        }
    }
}

#Preview {
    LoginView()
}
