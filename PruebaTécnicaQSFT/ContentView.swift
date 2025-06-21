//
//  ContentView.swift
//  PruebaTécnicaQSFT
//
//  Created by Adrian Pascual Dominguez Gomez on 21/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button("Prueba Técnica QSFT") {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let window = scene.windows.first,
                              let rootVC = window.rootViewController {
                               let vc = LocationListRouter.createModule()
                                vc.modalPresentationStyle =    .fullScreen
                               rootVC.present(vc, animated: true)
                           }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
