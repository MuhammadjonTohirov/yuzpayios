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
    @Published var showPickerOptions = false
    @Published var avatar: UIImage = #imageLiteral(resourceName: "image_avatar_placeholder_2.png")
    
    var route: UploadAvatarRoute? {
        didSet {
            push = route != nil
        }
    }
    
    @Published var push = false
    var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
    func onSelect(pickerOption option: UIImagePickerController.SourceType) {
        sourceType = option
        showImagePicker = true
    }
    
    func onClickSave() {
        setupPin()
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
}
