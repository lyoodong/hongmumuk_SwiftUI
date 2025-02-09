//
//  ValidationManager.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/9/25.
//

import Foundation

protocol ValidationManager {
    var univType: Univ { get set }
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
}

class ValidationManagerImp: ValidationManager {
    init(_ univType: Univ) {
        self.univType = univType
    }
    
    var univType: Univ
    
    func isValidEmail(_ email: String) -> Bool {
        return email.range(of: univType.emailRegex, options: .regularExpression) != nil
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.range(of: univType.passwordRegex, options: .regularExpression) != nil
    }
}
