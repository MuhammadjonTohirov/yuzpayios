//
//  InitUserAvatarView.swift
//  YuzPay
//
//  Created by applebro on 17/12/22.
//

import Foundation
import SwiftUI
import YuzSDK

struct UploadAvatarView: View {
    @ObservedObject var viewModel: UploadAvatarViewModel = UploadAvatarViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var cameraModel: CameraModel!
    
    @State private var scanerTimer: Timer?
    @State private var isScanning: Bool = false
    @State private var startCamera: Bool = false
    @State private var scanPeriod = 0
    
    @ViewBuilder var body: some View {
        innerBody
            .overlay {
                counterView
            }
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
                .padding(.top, Padding.large)
                .opacity(isScanning ? 0.2 : 1)
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
                .padding(.horizontal, Padding.default)
                .padding(.top, Padding.default)
                .opacity(isScanning ? 0.2 : 1)
            Spacer()
            
            HoverButton(
                title: "next".localize,
                backgroundColor: Color("accent_light_2"),
                titleColor: .white,
                isEnabled: !isScanning
            ) {
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
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1.5)
        .onAppear {
            self.cameraModel = .init(.front)
            self.startCamera = true
            self.viewModel.onAppear()

            if !cameraModel.service.isSessionRunning {
                cameraModel.service.start()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
        
        scanerTimer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if scanPeriod >= 5 {
                self.stopScanning()
            }
            scanPeriod += 1
        })
    }
    
    private func invalidateScanningTimer() {
        scanerTimer?.invalidate()
        scanerTimer = nil
        scanPeriod = 0
    }
    
    private func startScanning() {
        DispatchQueue.main.async {
            self.cameraModel.startRunning()
            self.isScanning = true
            self.cameraModel.startRecording()
            self.setupScanningTimer()
            SEffect.rigid()
        }
    }
    
    private func stopScanning() {
        DispatchQueue.main.async {
            self.isScanning = false
            self.cameraModel.stopRecording()
            self.invalidateScanningTimer()
            SEffect.rigid()
        }
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
    
    private var counterView: some View {
        VStack {
            Circle()
                .frame(width: 64, height: 64)
                .foregroundStyle(.background)
                .opacity(0.7)
                .overlay {
                    Text("\(5 - scanPeriod)")
                        .font(.system(size: 36, weight: .semibold))
                }
        }
        .opacity(isScanning ? 1 : 0)
    }
}

struct UploadAvatarView_Preview: PreviewProvider {
    static var previews: some View {
        UploadAvatarView()
    }
}
