//
//  SignupView.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 06.04.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    @Binding var presentedAsModal: Bool
    @ObservedObject private var signupViewModel = SignUpViewModel()

    var body: some View {
        VStack {
            Text("Sign Up")
            TextField("Enter your email...", text: $signupViewModel.email)
            TextField("Enter your password...", text: $signupViewModel.password)
            Button("Sign Up") {
                self.signupViewModel.buttonPressed = true
            }.disabled(!signupViewModel.buttonEnabled)

            ActivityIndicator(shouldAnimate: $signupViewModel.buttonPressed)

            Button("dismiss") { self.dissmiss() }
        }.onReceive(signupViewModel.$signUpSuccess) { success in
            guard success else { return }

            self.dissmiss()
        }
    }

    func dissmiss() {
        presentedAsModal = false
    }
}

// How to activate this?
//struct SignupView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupView()
//    }
//}
