//
//  ValidationClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import Dependencies

struct ValidationClient {
    var validateEmail: (_ email: String) -> Bool
    var validatePassword: (_ password: String) -> Bool
}

extension ValidationClient: DependencyKey {
    static func live(univType: Univ) -> Self {
        return .init(
            validateEmail: { email in
                email.range(of: univType.emailRegex, options: .regularExpression) != nil
            },
            validatePassword: { password in
                password.range(of: univType.passwordRegex, options: .regularExpression) != nil
            }
        )
    }
    
    static var liveValue = ValidationClient.live(univType: .hongik)
}

extension DependencyValues {
    var validationClient: ValidationClient {
        get { self[ValidationClient.self] }
        set { self[ValidationClient.self] = newValue }
    }
}
