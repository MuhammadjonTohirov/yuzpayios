//
//  UploadAvatarViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import UIKit
import SwiftUI
import YuzSDK

enum UploadAvatarRoute: ScreenRoute, Identifiable, Hashable {
    
    static func == (lhs: UploadAvatarRoute, rhs: UploadAvatarRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        switch self {
        case .setupPin:
            return "setupPin"
        }
    }
    
    case setupPin(model: PinCodeViewModel?)
    
    var screen: some View {
        switch self {
        case .setupPin(let model):
            return PinCodeView(viewModel: model ?? .init(title: "", reason: .setup))
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class UploadAvatarViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .hud, type: .regular)
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var showImagePicker = false

    @Published var avatar: UIImage = #imageLiteral(resourceName: "image_avatar_placeholder_2.png")
    
    @Published var imageUrl: URL?
    
    @Published var uploading: Bool = false
    
    @Published var dismiss = false
    
    private(set) var uploadAvatarResult = false
        
    var route: UploadAvatarRoute? {
        didSet {
            push = route != nil
        }
    }
    
    @Published var push = false
    
    var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
    
    private var didAppear = false
    
    func onAppear() {
        if !didAppear {
            didAppear = true
        }
    }
    
    private func trackSuccessRegistration() {
        
    }
    
    func onSelect(pickerOption option: UIImagePickerController.SourceType) {
        sourceType = option
        showImagePicker = true
    }
    
    func onClickSave() {
        guard let url = self.imageUrl else {
            self.showError(message: "first_select_photo".localize)
            return
        }
        self.startUploading()
        
        UserNetworkService.shared.uploadAvatar(url: url) { success, error in
            self.stopUploading()
            if success {
                Logging.l("Uploading avatar is successfull")
                self.onSuccessRegister()
            } else {
                self.showError(message: error ?? "Unknown")
                Logging.l("Failure \(error ?? "Unknown")")
            }
        }
    }
    
    private func setupPin() {
        let model: PinCodeViewModel = .init(title: "setup_pin".localize, reason: .setup)
        model.onResult = { [weak self] isOK in
            
            guard let _ = self else {
                return
            }
            
            if isOK {
                mainRouter?.navigate(to: .main)
            }
        }
        
        route = .setupPin(model: model)
    }
    
    private func onSuccessRegister() {
        self.showCustomAlert(alert: .init(displayMode: .banner(.pop),
                                          type: .complete(.accentColor),
                                          title: "Account created!"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.goToAuthScreen()
        }
    }
    
    private func goToAuthScreen() {
        mainRouter?.navigate(to: .auth)
        dismiss = true
    }
    
    private func startUploading() {
        DispatchQueue.main.async {
            self.uploading = true
        }
    }
    
    private func stopUploading() {
        DispatchQueue.main.async {
            self.uploading = false
        }
    }
}
