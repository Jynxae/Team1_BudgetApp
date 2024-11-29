//
//  Team1_BudgetingAppApp.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 9/28/24.
//

import SwiftUI
import Firebase

@main
struct Team1_BudgetingAppApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            SplashScreenView() // No arguments needed here
        }
    }
}
