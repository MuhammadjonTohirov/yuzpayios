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
    @State private var cameraModel: CameraModel!
    
    @State private var scanerTimer: Timer?
    @State private var isScanning: Bool = false
    @State private var startCamera: Bool = false
    
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
            Text("scan_face_title".localize)
                .font(.mont(.extraBold, size: 32))
                .foregroundColor(Color("accent_light"))
                .padding(.top, 64)
            
            Circle()
                .overlay(content: {
                    cameraView
                })
            .frame(width: 200, height: 200)
            .background(Color.red)
            .clipShape(Circle())
            .overlay {
                if viewModel.uploading {
                    SpringLoaderView()
                }
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
        .onAppear {
            self.cameraModel = .init()
            self.startCamera = true
            self.viewModel.onAppear()
            if !cameraModel.service.isSessionRunning {
                cameraModel.service.start()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.cameraModel.flipCamera(.front)
                self.cameraModel.onStartRecording = {
                    debugPrint("Recording started")
                }
                
                self.cameraModel.onEndRecording = { video in
                    viewModel.imageUrl = video?.videoUrl
                    debugPrint("Recording ended \(video!.videoUrl), \(video!.videoUrl.fileSize)")
                    
                }
            }
        }
    }
    
    private func setupScanningTimer() {
        invalidateScanningTimer()
        
        scanerTimer = .scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
            self.stopScanning()
        })
    }
    
    private func invalidateScanningTimer() {
        scanerTimer?.invalidate()
        scanerTimer = nil
    }
    
    private func startScanning() {
        if !cameraModel.session.isRunning {
            cameraModel.session.startRunning()
        }
        isScanning = true
        cameraModel.startRecording()
        setupScanningTimer()
    }
    
    private func stopScanning() {
        isScanning = false
        cameraModel.stopRecording()
        if cameraModel.session.isRunning {
            cameraModel.session.stopRunning()
        }
        invalidateScanningTimer()
    }
    
    @ViewBuilder
    private var cameraView: some View {
        if startCamera {
            CameraView(model: cameraModel, aspectRatio: .resizeAspectFill) {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white.opacity(0.5))
                    .overlay {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .overlay {
                                Image("icon_camera_full")
                                    .resizable(true)
                                    .frame(width: 32, height: 32)
                            }
                            .onTapGesture {
                                if viewModel.uploading {
                                    return
                                }
                                
                                startScanning()
                            }
                            
                    }
                    .visible(!isScanning, animation: .easeIn)
            }
        }
    }
}

struct UploadAvatarView_Preview: PreviewProvider {
    static var previews: some View {
        UploadAvatarView()
    }
}
