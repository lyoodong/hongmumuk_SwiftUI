//
//  LoginFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 2/10/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginFeature: Reducer {
    struct State {
        var showSingIn: Bool = false // true일 경우에만, 화면 전환
        var showSingUp: Bool = false // true일 경우에만, 화면 전환
    }
    
    // 화면의 생명주기 때문에, signInButtonTapped을 누르고 화면을 이동한 state가 여전히 남아있음(showSingIn = true)
    // 이 상태에서 pop하고, signUpButtonTapped 액션을 취하면 둘다 true이기 때문에 모순
    // 따라서, 화면 전환 시 OnDissappear 내부에서 dismiss 액션을 처리해줘야함
    enum Action {
        case signInButtonTapped
        case signUpButtonTapped
        case dismissSignIn
        case dismissSignUp
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signInButtonTapped:
                state.showSingIn = true
                return .none
            case .signUpButtonTapped:
                state.showSingUp = true
                return .none
            case .dismissSignIn:
                state.showSingIn = false
                return .none
            case .dismissSignUp:
                state.showSingUp = false
                return .none
            }
        }
    }
}
