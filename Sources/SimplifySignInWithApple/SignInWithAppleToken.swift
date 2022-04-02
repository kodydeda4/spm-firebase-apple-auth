import CryptoKit
import AuthenticationServices

public struct SignInWithAppleToken: Equatable {
  public let appleID: String
  public let nonce: String
  
  public init(appleID: String, nonce: String) {
    self.appleID = appleID
    self.nonce = nonce
  }
}

extension SignInWithAppleToken {
  static func from(
    _ result: Result<ASAuthorization, Error>,
    _ nonce: String
  ) -> SignInWithAppleToken? {
    try? (result.map(\.credential).get() as? ASAuthorizationAppleIDCredential)
      .flatMap(\.identityToken)
      .flatMap({ String(data: $0, encoding: .utf8) })
      .map({ SignInWithAppleToken(appleID: $0, nonce: nonce) })
  }
}
