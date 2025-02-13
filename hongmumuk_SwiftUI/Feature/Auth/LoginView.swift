//
//  LoginView.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/13/25.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    @ObservedObject var viewStore: ViewStoreOf<LoginFeature>
    
    init(store: StoreOf<LoginFeature>) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Image("Logo_Blue")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.23)
                    .padding(.bottom, geometry.size.height * 0.2)
                
                LoginButton(
                    title: "이메일로 로그인",
                    iconName: "LoginMailIcon",
                    action: {
                        viewStore.send(.signInButtonTapped)
                    }
                )
                .frame(height: geometry.size.height * 0.076)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                
                Button(action: {
                    viewStore.send(.signUpButtonTapped)
                }, label: {
                    Text("회원 가입")
                        .fontStyle(Fonts.body1Medium)
                        .foregroundColor(Colors.GrayScale.alternative)
                })
                .padding(.bottom, geometry.size.height * 0.1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationDestination(
            isPresented: viewStore.binding(
                get: { $0.activeScreen == .signIn },
                send: .onDismiss
            )
        ) {
            // SignIn View
        }
        .navigationDestination(
            isPresented: viewStore.binding(
                get: { $0.activeScreen == .signUp },
                send: .onDismiss
            )
        ) {
            // SignUpView
        }
    }
}

struct LoginButton: View {
    let title: String
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "FBFBFE"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Colors.Border.normal, lineWidth: 1)
                    )
                
                Text(title)
                    .fontStyle(Fonts.heading2Bold)
                    .foregroundColor(Colors.GrayScale.normal)
                
                HStack {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 20)
                    
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
