//
//  AuthViewModel.swift
//  Dog Trackin
//
//  Created by Luke Busch on 3/19/26.
//

import FirebaseAuth

@Observable
final class AuthViewModel {
    var user: FirebaseAuth.User?
    var isAuthenticated = false

    private var authStateHandle: AuthStateDidChangeListenerHandle?

    init() {
        // Analogous to a StateFlow in your auth repo
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isAuthenticated = user != nil
        }
    }

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
