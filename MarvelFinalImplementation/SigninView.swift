//
//  ContentView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 22.02.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import SwiftUI
import Combine


struct SigninView: View {
    @ObservedObject private var loginViewModel = LoginViewModel()
    @State var presentingSignUpView = false

    var body: some View {
        VStack {
            Text("Welcome to the Marvel world")
                       .padding()
                       .font(.largeTitle)
                       .foregroundColor(.white)
                .multilineTextAlignment(.center)
            HStack {
                Image(systemName: "person.circle")
                TextField("Enter your email...", text: $loginViewModel.email)
                    .foregroundColor(.white)
            }.padding(.horizontal, 60)
            .padding(.vertical, 10)

            HStack {
                Image(systemName: "lock.circle")
                           TextField("Enter your password...", text: $loginViewModel.password)
                     .foregroundColor(.white)
            }.padding(.horizontal, 60)
            .padding(.vertical, 10)

            Button("Sign In") {
                self.loginViewModel.buttonPressed = true
                }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40).background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(40)
                .padding(.vertical, 10)
                .padding(.horizontal, 60)

            .disabled(!loginViewModel.buttonEnabled)

            ActivityIndicator(shouldAnimate: $loginViewModel.buttonPressed)

            Text("Do not have an account?").foregroundColor(.white).padding()
            Button("Sign up here") {
                self.presentingSignUpView = true
            }.sheet(isPresented: $presentingSignUpView) {
                SignupView(presentedAsModal: self.$presentingSignUpView)
            }
            Spacer()
        }.background(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
