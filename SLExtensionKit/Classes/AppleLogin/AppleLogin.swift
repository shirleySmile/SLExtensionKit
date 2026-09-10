//
//  AppleLogin.swift
//  SWToolKit
//
//  Created by shirley on 2022/4/8.
//

import Foundation
import AuthenticationServices

public struct AppleUser{
    public var userId:String?
    public var userName:String?
    public var authCode:String?
    public var token:String?
}


/// 纯逻辑层：只负责解析授权结果，不依赖 UIKit，不持有窗口。
/// 展示层由调用方决定（SwiftUI 用 SignInWithAppleButton 等）。
public class AppleLogin: NSObject {
    
    public enum AppleLoginResultType {
        case success
        case fail
        case nonSupport
        case userCancel
    }
    
    public typealias resultClosure = (AppleLoginResultType, AppleUser?)->()
    
    /// 结果回调（调用方设置，handleAuthorization 会在主线程回传）
    public var resultHandler:resultClosure?
    
    /// SwiftUI 的 SignInWithAppleButton onCompletion 结果直接传入
    public func handleAuthorization(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            deliver(type: .success, user: Self.parse(authorization))
        case .failure(let error):
            let type: AppleLoginResultType =
                (error as? ASAuthorizationError)?.code == .canceled ? .userCancel : .fail
            deliver(type: type, user: nil)
        }
    }
    
    /// 纯逻辑：ASAuthorization -> AppleUser
    public static func parse(_ authorization: ASAuthorization) -> AppleUser? {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let code = appleIDCredential.authorizationCode.map { String(data: $0, encoding: .utf8) } ?? nil
            let token = appleIDCredential.identityToken.map { String(data: $0, encoding: .utf8) } ?? nil
            return AppleUser(userId: appleIDCredential.user,
                             userName: appleIDCredential.fullName?.nickname,
                             authCode: code,
                             token: token)
        case let passwordCredential as ASPasswordCredential:
            return AppleUser(userId: passwordCredential.user, userName: "", authCode: "", token: "")
        default:
            return nil
        }
    }
    
    private func deliver(type: AppleLoginResultType, user: AppleUser?) {
        DispatchQueue.main.async {
            if self.resultHandler != nil {
                self.resultHandler!(type, user)
                self.resultHandler = nil
            }
        }
    }
}
