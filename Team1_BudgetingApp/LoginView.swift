import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""

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
                Text("Sign In")
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
                
                // Sign In Button
                Button(action: {
                    // Handle sign-in action
                }) {
                    Text("Sign in")
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
                
                //Forgot Password
                Button(action: {
                    // Handle Forgot password action
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(Color("PrimaryPink"))
                        .fontWeight(.semibold)
                        .font(.callout)
                }

                Spacer()
                
                //Sign up
                Button(action: {
                    // Handle Sign Up action
                }) {
                    Text("Don’t have an account?")
                    Text("Sign Up")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color("PrimaryPink"))

            }
        }
    }
}

#Preview {
    LoginView()
}
