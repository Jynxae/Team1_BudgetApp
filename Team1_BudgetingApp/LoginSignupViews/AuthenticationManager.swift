import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let password: String? // Added password field for mock purposes
    
    init(user: User, password: String? = nil) {
        self.uid = user.uid
        self.email = user.email
        self.password = password
    }
}

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private let db = Firestore.firestore() // Firestore instance
    private init() { }
    
    func createUser(email: String, password: String, firstName: String, lastName: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authDataResult.user
        
        // Save user info including plaintext password to Firestore
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password, // Store plaintext password (for mock purposes)
            "uid": user.uid
        ]
        
        try await db.collection("users").document(user.uid).setData(userData)
        
        return AuthDataResultModel(user: user, password: password)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        // First, sign in with Firebase Authentication
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = authDataResult.user
        
        // Check the stored password in Firestore
        let document = try await db.collection("users").document(user.uid).getDocument()
        guard let data = document.data(),
              let storedPassword = data["password"] as? String,
              storedPassword == password else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password."])
        }
        
        return AuthDataResultModel(user: user, password: password)
    }
    
    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
