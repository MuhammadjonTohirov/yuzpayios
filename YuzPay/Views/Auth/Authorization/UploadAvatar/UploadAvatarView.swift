//
//  InitUserAvatarView.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI
import SwiftUIX

struct UploadAvatarView: View {
    @ObservedObject var viewModel: UploadAvatarViewModel = UploadAvatarViewModel()
    
    @ViewBuilder var body: some View {
        ZStack {
            NavigationLink("", isActive: $viewModel.push, destination: {
                viewModel.route?.screen ?? EmptyView()
            })
            .zIndex(2)
            innerBody
        }
    }
    
    var innerBody: some View {
        VStack {
            Text("to_select_photo".localize)
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))
                .padding(.top, 64)
            
            Image(uiImage: viewModel.avatar)
                .resizable(true)
                .frame(width: 140.f.sw(), height: 140.f.sw())
                .cornerRadius(70)
                .foregroundLinearGradient(
                    Gradient(colors: [.black.opacity(0.2), .clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .padding(.bottom, 48)
                .onTapGesture {
                    self.viewModel.showPickerOptions = true
                }
            
            Text("pick_image_from_camera_or_gallery".localize)
                .font(.mont(.regular, size: 16))
                .foregroundColor(Color("label_color"))
         
            Spacer()
            
            HoverButton(title: "next".localize, backgroundColor: Color("accent_light_2"), titleColor: .white) {
                viewModel.onClickSave()
            }
            .padding(.horizontal, Padding.large)
            .padding(.bottom, Padding.medium)
        }
        .multilineTextAlignment(.center)
        .confirmationDialog("Pick image", isPresented: $viewModel.showPickerOptions, actions: {
            
            Button("from_gallery".localize) {
                viewModel.onSelect(pickerOption: .photoLibrary)
            }
            
            Button("from_camera".localize) {
                viewModel.onSelect(pickerOption: .camera)
            }
        }, message: {
            Text("Get image from gallery or camera")
        })
        
        .fullScreenCover(isPresented: $viewModel.showImagePicker, content: {
            ImagePicker(
                sourceType: viewModel.sourceType,
                selectedImage: $viewModel.avatar)
            .ignoresSafeArea()
        })
        .zIndex(2)
    }
}

struct UploadAvatarView_Preview: PreviewProvider {
    static var previews: some View {
        UploadAvatarView()
    }
}