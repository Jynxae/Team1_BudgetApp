import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    //FirebaseApp.configure()

    return true
  }
}

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var isSignedIn: Bool = false
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some View {
        VStack {
            if isSignedIn {
                TabView(selection: $selectedTab) {
                    MyFinancesView(selectedTab: $selectedTab).tabItem {
                        Image(systemName: "house.fill")
                            .font(.system(size: 24)) // Adjust the size as needed
                        Text("Home")
                    }
                    .tag(1)
                    
                    EditBudgetView().tabItem {
                        if selectedTab == 2 {
                            Image("piggybank-fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        } else {
                            Image("piggybank")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                        Text("Budget")
                    }
                    .tag(2)
                    
                    FinanceReportsView().tabItem {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Reports")
                    }
                    .tag(3)
                    
                    SettingsView(isSignedIn: $isSignedIn) // Pass the binding
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                    .tag(4)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isSignedIn)
            } else {
                LoginView(isSignedIn: $isSignedIn)
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(named: "primaryLightPink")
            UITabBar.appearance().barTintColor = UIColor(named: "primaryLightPink")
        }
    }
}

#Preview {
    ContentView()
}
