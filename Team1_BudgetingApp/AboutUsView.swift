import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Use HeaderView for the top section
                VStack{
                Spacer()
                        .frame(height: 70)
                    Text("About Us")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color("primaryLightPink"))
                
                // App Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome to Team1 Budgeting App!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("primaryPink"))
                        .padding(.top, 20)
                    
                    Text("""
                    Our app is designed to help you manage your finances effortlessly. Whether you’re tracking expenses, setting budgets, or saving for your goals, Team1 Budgeting App has you covered.
                    
                    We aim to make financial management simple, effective, and accessible to everyone. We believe that anyone can take control of their finances with the right tools, and we're here to provide those tools.
                    
                    Thank you for choosing Team1 Budgeting App. We hope it helps you on your journey to better financial health!
                    """)
                        .font(.body)
                        .foregroundColor(Color("GrayText"))
                }
                .padding(.horizontal)
                
                // Team Info
                VStack(alignment: .leading, spacing: 10) {
                    Text("Our Team")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("primaryPink"))
                        .padding(.top, 20)
                    
                    Text("""
                    We are a group of passionate developers dedicated to building user-friendly and effective solutions. Our team is committed to providing the best experience for our users, continuously improving  the app based on your feedback.
                    
                    Feel free to reach out to us for any suggestions or support. We’d love to hear from you!
                    """)
                        .font(.body)
                        .foregroundColor(Color("GrayText"))
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    AboutUsView()
}
