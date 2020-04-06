//
//  ActivityIndicator.swift
//  MarvelFinalImplementation
//
//  Created by Fernando Cardenas on 06.04.20.
//  Copyright © 2020 fernandocardenasm. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        shouldAnimate ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
