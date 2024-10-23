import SwiftUI

struct SettingsView: View {
    @Binding var isSignedIn: Bool // Binding to control sign-in state

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Header with title
                    HeaderView(title: "Settings", color: "primaryLightPink")
                    
                    Spacer().frame(height: 50)
                    
                    // Profile Icon and Welcome Text
                    VStack(spacing: 10) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color("primaryPink"))
                            .background(Circle().fill(Color.white))
                            .padding(.top, -30)
                        
                        Text("Welcome, John Doe")
                            .font(.system(size: 24))
                            .foregroundColor(Color("primaryPink"))
                            .fontWeight(.bold)
                    }
                    .padding(.bottom, 30)
                    
                    // Settings List
                    VStack(spacing: 15) {
                        // Navigate to ProfileView
                        NavigationLink(destination: ProfileView()) {
                            SettingsRow(icon: "person.fill", text: "Profile", color: Color("primaryPink"))
                        }

                        // Navigate to About Us
                        NavigationLink(destination: AboutUsView()) {
                            SettingsRow(icon: "info.circle.fill", text: "About Us", color: Color("primaryPink"))
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                        .frame(height: 300)
                    
                    // Logout Button
                    Button(action: {
                        isSignedIn = false // Change the state to show LoginView
                    }) {
                        Text("Logout")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: 190)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color("primaryPink"))
                            .cornerRadius(20)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.bottom, 30)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

// Reusable Component for Settings Row
struct SettingsRow: View {
    var icon: String
    var text: String
    var color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(text)
                .fontWeight(.semibold)
                .foregroundColor(color)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .padding(.horizontal, 30)
    }
}

#Preview {
    SettingsView(isSignedIn: .constant(true))
}
