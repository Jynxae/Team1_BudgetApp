import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SettingsViewModel: ObservableObject {
    @Published var userName: String = "Loading..."
    private let db = Firestore.firestore()
    
    init() {
        fetchUserName()
    }
    
    func fetchUserName() {
        guard let currentUser = Auth.auth().currentUser else {
            userName = "User"
            return
        }
        
        db.collection("users").document(currentUser.uid).getDocument { [weak self] (document, error) in
            if let document = document, document.exists,
               let data = document.data(),
               let firstName = data["firstName"] as? String,
               let lastName = data["lastName"] as? String {
                self?.userName = "\(firstName) \(lastName)"
            } else {
                self?.userName = "User"
            }
        }
    }
}

struct SettingsView: View {
    @Binding var isSignedIn: Bool // Binding to control sign-in state
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header with title
                VStack{
                    Spacer()
                        .frame(height: 70)
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color("primaryLightPink"))
                
                Spacer()
                    .frame(height: 50)
                
                // Profile Icon and Welcome Text
                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("primaryPink"))
                        .background(Circle().fill(Color.white))
                        .padding(.top, -30)
                    
                    Text("Welcome, \(viewModel.userName)")
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
                    do {
                        try Auth.auth().signOut()
                        isSignedIn = false // Change the state to show LoginView
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
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
