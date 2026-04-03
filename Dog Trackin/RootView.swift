//
//  RootView.swift
//  Dog Trackin
//
//  Created by Luke Busch on 4/3/26.
//

import SwiftUI

struct RootView: View {
    @Environment(\.authViewModel) private var authViewModel

    var body: some View {
        if authViewModel.isAuthenticated {
            ContentView()
        } else {
            LoginView()
        }
    }
}
