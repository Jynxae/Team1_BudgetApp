//
//  ProfileViewModel.swift
//  Team1_BudgetingApp
//
//  Created by Sue on 12/3/24.
//

import FirebaseAuth
import Combine

class ProfileViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var password = "password"
    @Published var isLoading = false

    private let authManager = AuthenticationManager.shared
    private var cancellables = Set<AnyCancellable>()
        
    func loadUserData() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let data = try await authManager.fetchUserData(uid: userId)
            DispatchQueue.main.async {
                self.firstName = data["firstName"] as? String ?? ""
                self.lastName = data["lastName"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
                self.phoneNumber = data["phoneNumber"] as? String ?? ""
                self.isLoading = false
            }
        } catch {
            print("Error loading user data: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    func saveUserData() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }
        
        let updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phoneNumber": phoneNumber
        ]
        
        do {
            try await authManager.updateUserData(uid: userId, data: updatedData)
            print("User data updated successfully.")
            DispatchQueue.main.async {
                self.isLoading = true
            }
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func changeEmail(newEmail: String, password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }

        // Reauthenticate the user
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.reauthenticate(with: credential) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }

        // Send email verification before updating the email
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }

        DispatchQueue.main.async {
            self.email = newEmail
        }
    }
}
