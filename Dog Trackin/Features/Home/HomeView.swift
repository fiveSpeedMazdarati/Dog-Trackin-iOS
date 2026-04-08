//
//  HomeView.swift
//  Dog Trackin
//
//  Created by Luke Busch on 4/7/26.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Environment(\.authViewModel) private var authViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "pawprint.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)

                Text("Welcome!")
                    .font(.largeTitle.bold())

                if let email = authViewModel.user?.email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Dog Trackin")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                }
            }
        }
    }
}
