# AGENTS.md — Dog Trackin

## Project Overview

Dog Trackin is an iOS app built with SwiftUI targeting iOS. It uses Firebase for backend services and SwiftData for local persistence. The app is in early development with authentication implemented and a placeholder home screen.

## Tech Stack

- **UI Framework:** SwiftUI
- **Local Persistence:** SwiftData (`ModelContainer`, `@Model`)
- **Backend/Auth:** Firebase (FirebaseAuth, Google Sign-In, Sign In with Apple)
- **Minimum Target:** iOS (see Xcode project for specific version)
- **Package Dependencies:** Firebase SDK, GoogleSignIn, GoogleSignInSwift, AuthenticationServices, CryptoKit

## Architecture

### Pattern
The project follows a **feature-based folder structure** with ViewModels using Swift's `@Observable` macro. Dependencies are passed through the SwiftUI `Environment` using custom `EnvironmentValues` entries (see `AppEnvironment.swift`).

### Key Architectural Decisions
- **@Observable over ObservableObject:** ViewModels use the `@Observable` macro, not `ObservableObject`/`@Published`.
- **Environment-based DI:** ViewModels are injected via `@Environment` using custom `@Entry` keys defined in `AppEnvironment.swift`, not passed as init parameters or singletons.
- **Feature folders:** Each feature lives under `Features/<FeatureName>/` containing its views, view models, and repositories.

## Project Structure

```
Dog Trackin/
├── Dog_TrackinApp.swift      # App entry point, Firebase config, Google Sign-In setup
├── RootView.swift            # Auth-gated root: shows HomeView or LoginView
├── AppEnvironment.swift      # Custom EnvironmentValues (@Entry for authViewModel)
├── ContentView.swift         # Default SwiftData template view (unused placeholder)
├── Item.swift                # SwiftData @Model (template placeholder)
├── Info.plist                # URL schemes for Google Sign-In
├── Features/
│   ├── Auth/
│   │   ├── AuthViewModel.swift    # @Observable VM: email/password, Google, Apple sign-in
│   │   ├── AuthRepository.swift   # Empty — intended for auth data layer abstraction
│   │   └── LoginView.swift        # Login/signup form with social sign-in buttons
│   └── Home/
│       └── HomeView.swift         # Post-auth landing screen with sign-out
```

## Code Style

- **Naming:** PascalCase for types, camelCase for properties/methods
- **State:** `@State private var` for SwiftUI local state, `let` for constants
- **Views:** Conform to `View` protocol, define UI in `body`
- **Indentation:** 4 spaces
- **Imports:** Minimal, specific imports at top of file
- **Types:** Leverage Swift's strong type system; avoid force unwrapping
- **Testing:** Use the Swift Testing framework (`@Test`, `#expect`) for unit tests, XCUIAutomation for UI tests

## Important Notes

- `GoogleService-Info.plist` is gitignored and must be present locally for Firebase to work. Never commit it.
- `AuthRepository.swift` exists but is currently empty — it is intended as the future data layer for auth.
- `ContentView.swift` and `Item.swift` are Xcode template leftovers still referenced by the SwiftData `ModelContainer`. They can be replaced when real data models are introduced.
- The `AppDelegate` in `Dog_TrackinApp.swift` is minimal and exists to support `UIApplicationDelegateAdaptor`.
- Auth state is observed via `Auth.auth().addStateDidChangeListener` in `AuthViewModel.init()`.
