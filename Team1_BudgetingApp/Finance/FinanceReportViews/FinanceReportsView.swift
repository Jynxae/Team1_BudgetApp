import SwiftUI

struct FinanceReportsView: View {
    @State private var selectedTab: String = "Current Month"
    let tabs = ["Current Month", "Current Year"]

    var body: some View {
        VStack() {
            HeaderView(title: "Finance Report", color: "primaryLightPink")
            
            // Custom tab selector
            tabSelector
            
            // Content based on selected tab
            if selectedTab == "Current Month" {
                FinanceMonthView()
            } else {
                FinanceYearView()
            }
        }
    }

    // Custom tab selector
    var tabSelector: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .fontWeight(selectedTab == tab ? .bold : .regular)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        selectedTab == tab ? Color.primaryPink.opacity(0.2) : Color.clear
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = tab
                        }
                    }
                    .foregroundColor(selectedTab == tab ? Color.primaryPink : Color.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Reusable Component for Header
struct HeaderView: View {
    var title: String
    var color: String
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 15)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 8)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color(color))
    }
}


// Preview
#Preview {
    FinanceReportsView()
}
