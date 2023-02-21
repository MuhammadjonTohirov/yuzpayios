//
//  UploadAvatarViewModel.swift
//  YuzPay
//
//  Created by applebro on 18/12/22.
//

import Foundation
import UIKit
import SwiftUI

enum UploadAvatarRoute: ScreenRoute, Identifiable, Hashable {
    static func == (lhs: UploadAvatarRoute, rhs: UploadAvatarRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: Int {
        switch self {
        case .setupPin:
            return 0
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

final class UploadAvatarViewModel: ObservableObject {
    @Published var showImagePicker = false

    @Published var avatar: UIImage = #imageLiteral(resourceName: "image_avatar_placeholder_2.png")
    
    @Published var imageUrl: URL?
    
    @Published var uploading: Bool = false
    
    var alertMessage: String?
    
    @Published var showAlert = false
    
    var route: UploadAvatarRoute? {
        didSet {
            push = route != nil
        }
    }
    
    @Published var push = false
    var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
    
    func onAppear() {
        #if DEBUG
        self.imageUrl = Bundle.main.url(forResource: "default_avatar", withExtension: "jpg")
        
        if let url = imageUrl,
            let data = try? Data.init(contentsOf: url),
            let image = UIImage.init(data: data) {
            self.avatar = image
        }
        #endif
    }
    
    func onSelect(pickerOption option: UIImagePickerController.SourceType) {
        sourceType = option
        showImagePicker = true
    }
    
    func onClickSave() {
        guard let url = self.imageUrl else {
            self.alert(with: "first_select_photo")
            return
        }
        self.startUploading()
        
        UserNetworkService.shared.uploadAvatar(url: url) { success, error in
            self.stopUploading()
            if success {
                Logging.l("Uploading avatar is successfull")
                mainRouter?.navigate(to: .auth)
            } else {
                self.alert(with: error ?? "Unknown")
                Logging.l("Failure \(error ?? "Unknown")")
            }
        }
    }
    
    func alert(with message: String) {
        DispatchQueue.main.async {
            self.showAlert = true
            self.alertMessage = message
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
