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
            Text("Sign Up to the Marvel App")
                   .padding()
                   .font(.largeTitle)
                   .foregroundColor(.white)
            .multilineTextAlignment(.center)

            LoginFieldsView(email: $signupViewModel.email, password: $signupViewModel.password)
            .padding(.horizontal, 60)
            
            Button("Sign Up") {
                self.signupViewModel.buttonPressed = true
            }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40).background(signupViewModel.buttonEnabled ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding(.vertical, 10)
            .padding(.horizontal, 60)
            .disabled(!signupViewModel.buttonEnabled)

            ActivityIndicator(shouldAnimate: $signupViewModel.buttonPressed)

            Button("dismiss") { self.dissmiss() }

            Spacer()
        }
        .background(Color.red)
        .onReceive(signupViewModel.$signUpSuccess) { success in
            guard success else { return }

            self.dissmiss()
        }
    }

    func dissmiss() {
        presentedAsModal = false
    }
}

// How to activate this?
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(presentedAsModal: .constant(false))
    }
}
