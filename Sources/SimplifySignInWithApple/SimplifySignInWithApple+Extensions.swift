import SwiftUI
import CryptoKit
import AuthenticationServices

public extension SignInWithAppleButton {
  init(
    requestedScopes: [ASAuthorization.Scope]? = [.fullName, .email],
    onCompletion handleLogin: @escaping ((SignInWithAppleToken) -> Void)
  ) {
    let currentNonce = SignInWithAppleButton.generateRandomNonce()
    
    self.init(
      onRequest: {
        $0.requestedScopes = requestedScopes
        $0.nonce = currentNonce.hash()
      },
      onCompletion: {
        if let credential = SignInWithAppleToken.from($0, currentNonce) {
          handleLogin(credential)
        }
      }
    )
  }
}

// MARK: - Helpers
private extension SignInWithAppleButton {
  static func generateRandomNonce(length: Int = 32) -> String {
    precondition(length > 0)
    let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }
      randoms.forEach { random in
        if length == 0 {
          return
        }
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    return result
  }
}

private extension String {
  func hash() -> String {
    SHA256
      .hash(data: Data(self.utf8))
      .compactMap { String(format: "%02x", $0) }
      .joined()
  }
}
