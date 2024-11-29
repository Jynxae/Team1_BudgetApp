//
//  AuthenticationManager.swift
//  Team1_BudgetingApp
//
//  Created by reem alkhalily on 11/28/24.
//

import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private let db = Firestore.firestore() // Firestore instance
    private init() { }
    
    func createUser(email: String, password: String, firstName: String, lastName: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authDataResult.user
        
        // Save additional user info to Firestore
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "uid": user.uid
        ]
        
        try await db.collection("users").document(user.uid).setData(userData)
        
        return AuthDataResultModel(user: user)
    }
}
