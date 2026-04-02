//
//  AppEnvironment.swift
//  Dog Trackin
//
//  Created by Luke Busch on 3/19/26.
//

import SwiftUI

// Define environment keys for your dependencies
extension EnvironmentValues {
    @Entry var authViewModel = AuthViewModel()
}
