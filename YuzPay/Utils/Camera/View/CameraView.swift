//
//  CameraView.swift
//  YuzPay
//
//  Created by applebro on 08/01/23.
//

import SwiftUI
import Combine
import AVFoundation

struct CameraView: View {
    @StateObject var model: CameraModel
    
    @State var currentZoomFactor: CGFloat = 1.0
    
    var aspectRatio: AVLayerVideoGravity = .resizeAspect
    
    var gradientColors: [Color] = [
        Color.black.opacity(0.7),
        Color.black.opacity(0),
        Color.black.opacity(0.7)
    ]

    var overlayBody: () -> any View
        
    var body: some View {
        ZStack {
            CameraPreview(session: model.session, aspectRatio: aspectRatio)
                .ignoresSafeArea()
                .onAppear {
                    model.configure()
                }
                .alert(isPresented: $model.showAlertError, content: {
                    Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                        model.alertError.primaryAction?()
                    }))
                })
                
            LinearGradient(
                colors: gradientColors,
                startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            AnyView(overlayBody())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var didCameraReady = false
    static var previews: some View {
        CameraView(model: CameraModel()) {
            Text("Capture")
                .foregroundColor(.systemBlue)
        }
    }
}
