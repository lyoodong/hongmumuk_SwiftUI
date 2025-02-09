//
//  ContentView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 1/19/25.
//

import SwiftUI

struct ContentView: View {
    let validationManager = ValidationManagerImp(.hongik)
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .onChange(of: email) { _, newValue in
                    isEmailValid = validationManager.isValidEmail(newValue)
                }
            
            Text(isEmailValid ? "유효한 이메일입니다" : "홍익대학교 이메일을 입력해주세요")
                .foregroundColor(isEmailValid ? .green : .red)
            
            TextField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: password) { _, newValue in
                    isPasswordValid = validationManager.isValidPassword(newValue)
                }
            
            Text(isPasswordValid ? "유효한 비밀번호입니다" : "영문, 숫자 포함 8~20자")
                .foregroundColor(isPasswordValid ? .green : .red)
        }
        .padding()
    }
}
