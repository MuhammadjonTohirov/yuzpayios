//
//  InitUserAvatarView.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI

struct UploadAvatarView: View {
    @ObservedObject var viewModel: UploadAvatarViewModel = UploadAvatarViewModel()
    @Environment(\.dismiss) var dismiss
    
    @ViewBuilder var body: some View {
        innerBody
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
        })
        .onChange(of: viewModel.dismiss, perform: { newValue in
            if newValue {
                dismiss()
            }
        })
        .onAppear {
            viewModel.onAppear()
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
                .aspectRatio(contentMode: .fill)
                .frame(width: 140.f.sw(), height: 140.f.sw())
                .cornerRadius(70)
                .foregroundLinearGradient(
                    Gradient(colors: [.black.opacity(0.2), .clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .overlay {
                    if viewModel.uploading {
                        SpringLoaderView()
                    }
                }
                .padding(.bottom, 48)
                .onTapGesture {
                    viewModel.onSelect(pickerOption: .camera)
                }
            
            Text("capture_avatar_from_camera".localize)
                .font(.mont(.regular, size: 16))
                .foregroundColor(Color("label_color"))
                .padding(.horizontal, Padding.large)
         
            Spacer()
            
            HoverButton(title: "next".localize, backgroundColor: Color("accent_light_2"), titleColor: .white) {
                viewModel.onClickSave()
            }
            .set(animated: viewModel.uploading)
            .padding(.horizontal, Padding.large)
            .padding(.bottom, Padding.medium)
        }
        .multilineTextAlignment(.center)
                
        .fullScreenCover(isPresented: $viewModel.showImagePicker, content: {
            ImagePicker(
                sourceType: viewModel.sourceType,
                selectedImage: $viewModel.avatar,
                imageUrl: $viewModel.imageUrl)
            .ignoresSafeArea()
        })
        .zIndex(2)
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1)
    }
}

struct UploadAvatarView_Preview: PreviewProvider {
    static var previews: some View {
        UploadAvatarView()
    }
}
