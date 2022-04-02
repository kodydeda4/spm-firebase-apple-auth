# SimplifySignInWithApple
This package simplifies the work needed to sign in with apple.
Just create a function which handles the token and you're good to go!

## Firebase Example
```Swift
import SwiftUI
import Firebase
import SimplifySignInWithApple
import AuthenticationServices

@main
struct Main: App {
  init() {
    FirebaseApp.configure()
  }
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  @State var user: User? = nil
  
  func signIn(with token: SignInWithAppleToken) {
    Task.init {
      user = try await Auth.auth().signIn(with: OAuthProvider.credential(
        withProviderID: "apple.com",
        idToken: token.appleID,
        rawNonce: token.nonce
      )).user
    }
  }
  
  var body: some View {
    SignInWithAppleButton() {
      signIn(with: $0)
    }
  }
}

```