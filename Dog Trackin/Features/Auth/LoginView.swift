//
//  LoginView.swift
//  Dog Trackin
//
//  Created by Luke Busch on 4/3/26.
//

import SwiftUI
import AuthenticationServices
import GoogleSignInSwift

struct LoginView: View {
    @Environment(\.authViewModel) private var authViewModel
    @Environment(\.colorScheme) private var colorScheme

    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.tint)
                    Text("Dog Trackin")
                        .font(.largeTitle.bold())
                    Text(isSignUpMode ? "Create your account" : "Welcome back")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)

                // Email/Password Form
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $password)
                        .textContentType(isSignUpMode ? .newPassword : .password)
                        .textFieldStyle(.roundedBorder)

                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        Task {
                            if isSignUpMode {
                                await authViewModel.signUp(email: email, password: password)
                            } else {
                                await authViewModel.signIn(email: email, password: password)
                            }
                        }
                    } label: {
                        Group {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(isSignUpMode ? "Create Account" : "Sign In")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSignUpMode.toggle()
                            authViewModel.errorMessage = nil
                        }
                    } label: {
                        Text(isSignUpMode
                             ? "Already have an account? Sign In"
                             : "Don't have an account? Sign Up")
                            .font(.footnote)
                            .foregroundStyle(.tint)
                    }
                }
                .padding(.horizontal, 32)

                // Divider
                HStack {
                    Rectangle().frame(height: 1).foregroundStyle(.quaternary)
                    Text("or")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                    Rectangle().frame(height: 1).foregroundStyle(.quaternary)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)

                // Social Sign-In Buttons
                VStack(spacing: 12) {
                    SignInWithAppleButton(
                        isSignUpMode ? .signUp : .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = authViewModel.prepareAppleSignIn()
                        },
                        onCompletion: { result in
                            Task {
                                await authViewModel.handleAppleSignIn(result: result)
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 50)

                    GoogleSignInButton(scheme: colorScheme == .dark ? .light : .dark, style: .wide) {
                        Task {
                            await authViewModel.signInWithGoogle()
                        }
                    }
                    .frame(height: 50)
                    .disabled(authViewModel.isLoading)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
