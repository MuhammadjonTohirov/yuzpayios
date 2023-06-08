//
//  UserIdentification.swift
//  YuzPay
//
//  Created by applebro on 08/01/23.
//

import Foundation
import SwiftUI
import AVKit
import YuzSDK
import RealmSwift

struct UserIdentificationView: View {
    @Environment(\.dismiss) var dismiss
    @State var scanPassport: Bool = false
    @State var image: UIImage = UIImage(named: "icon_camera")!
    @State var flashMode: AVCaptureDevice.FlashMode = .on
    @State var cameraPosition: AVCaptureDevice.Position = .back
    @State private var toast = AlertToast(displayMode: .alert, type: .regular)
    @State private var showToast = false
    @State private var isUploading = false
    
    let cameraModel = CameraModel()
    
    @State var isSuccess: Bool = false
    
    var withDismiss = true
    
    @ViewBuilder
    var body: some View {
        Group {
            if isSuccess {
                successView
            } else {
                defaultView
            }
        }
        .loadable($isUploading, message: "verifying".localize)
        .toast($showToast, toast, duration: 1)
    }
    
    var successView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image("image_success_2")
                .resizable(true)
                .frame(width: 100, height: 100)
                .padding(.bottom, Padding.medium)
            
            Text("Готово!")
                .mont(.semibold, size: 28)
            Text("Теперь вы можете использовать оплату лицом.")
                .mont(.regular, size: 16)
            
            Spacer()
            
            button
        }
    }
    
    var defaultView: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 14) {
                Text("Паспортные данные")
                    .mont(.semibold, size: 24)
                    .padding(.top, Padding.large * 2)
                Text("Паспортные данные необходимы, чтобы подтвердить Вашу личность и открыть полный доступ ко всем услугам.")
                    .mont(.regular, size: 14)
                
                Spacer()
                
                FlatButton(title: "Сканировать", borderColor: .clear, titleColor: .white) {
                    startScanning()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.accentColor)
                )
            }
            .fullScreenCover(isPresented: $scanPassport) {
                CameraView(model: cameraModel) {
                    cameraOverlay
                        .loadable($isUploading, message: "verifying".localize)
                }
                .onAppear {
                    if !cameraModel.service.isSessionRunning {
                        cameraModel.service.start()
                        cameraModel.onStartCapture = {
                            isUploading = true
                        }
                        cameraModel.onCapture = { url in
                            if let url {
                                uploadPhoto(url: url)
                            }
                            
                            stopScanning()
                        }
                    }
                }
            }
            
            if withDismiss {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("icon_x")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .position(x: 12, y: Padding.medium)
            }
        }
        .padding(Padding.default)
    }
    
    private func showAlert(_ toast: AlertToast) {
        self.toast = toast
        self.showToast = true
    }
    
    private func uploadPhoto(url: URL) {
        isUploading = true
        UserNetworkService.shared.verifyProfile(photoUrl: url) { success, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                success ? onSuccess() : onFail(error: error)
                isUploading = false
            }
        }
    }
    
    private func onFail(error: String?) {
        isSuccess = false
        showAlert(.init(displayMode: .alert, type: .error(.systemRed), title: error ?? "cannot_verify_try_again".localize))
    }
    
    private func onSuccess() {
        isSuccess = true
        Task {
            let _ = await loadUserInfo()
        }
    }
    
    private func loadUserInfo() async -> Bool {
        
        guard let userInfo = await UserNetworkService.shared.getUserInfo() else {
            return false
        }
        
        Realm.new?.trySafeWrite({
            Realm.new?.add(DUserInfo.init(id: UserSettings.shared.currentUserLocalId, res: userInfo), update: .modified)
        })
        
        return true
    }
    
    @ViewBuilder
    private var cameraOverlay: some View {
        VStack(alignment: .center, spacing: 14) {
            cameraOverlayHeader
            .padding(.horizontal, Padding.default)

            Text("Отсканируйте паспорт")
                .mont(.semibold, size: 28)
                .padding(.top, Padding.medium)
            Text("Направьте камеру на главную страницу паспорта так, чтобы она совпала с рамкой.")
                .mont(.regular, size: 16)
            
            Spacer()
            
            if let photo = cameraModel.photo, let image = photo.image?.cgImage {
                Image(uiImage: .init(cgImage: image))
                    .resizable(true)
                    .aspectRatio(contentMode: .fit)
                    .maxWidth(200)
                    .maxHeight(300)   
            }
            
            button
        }
        .padding(.top, Padding.large)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
    }
    
    var button: some View {
        FlatButton(title: isSuccess ? "finish".localize : "verify".localize, borderColor: .clear, titleColor: !isSuccess ? .accentColor : .white) {
            
            if isSuccess {
                dismiss()
            } else {
                cameraModel.capturePhoto()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(isSuccess ? .accentColor : .white)
        )
        .padding(.bottom, Padding.large)
        .padding(.horizontal, Padding.large)
    }
    
    private func stopScanning() {
        self.cameraModel.photo = nil
        if self.cameraModel.service.isSessionRunning {
            self.cameraModel.service.stop {
                self.scanPassport = false
            }
        } else {
            self.scanPassport = false
        }
    }
    
    private func startScanning() {
        self.scanPassport = true
    }
    
    var cameraOverlayHeader: some View {
        HStack {
            Button {
                stopScanning()
            } label: {
                Image("icon_x")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.black.opacity(0.3))
                    )
            }
            
            Spacer()
            
            Button {
                cameraModel.service.flashMode = cameraModel.service.flashMode == .on ? .off : .on
                cameraModel.service.reloadFlashMode()
            } label: {
                Image(systemName: "bolt.circle")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.black.opacity(0.3))
                    )
            }
            
        }
    }
    
}

struct UserIdentificationView_Preview: PreviewProvider {
    static var previews: some View {
        UserIdentificationView()
    }
}
