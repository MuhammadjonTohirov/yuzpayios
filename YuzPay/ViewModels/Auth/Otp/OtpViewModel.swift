//
//  OtpViewModel.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation
import YuzSDK

protocol OtpModelDelegate: NSObject {
    func otp(model: OtpViewModel, isSuccess: Bool)
}

final class OtpViewModel: ObservableObject {
    var title: String = "confirm_otp".localize
    var number: String = "935852415"
    var countryCode: String = "+998"
    
    var wholeNumber: String {
        countryCode + number.format(with: "XX XXX-XX-XX")
    }
    
    @Published var otp: String = ""
    @Published var isValidForm = false
    @Published var counter: String = ""
    @Published var shouldResend = false
    @Published var otpErrorMessage = "" {
        didSet {
            DispatchQueue.main.async {
                self.showAlert = !self.otpErrorMessage.isNilOrEmpty
            }
        }
    }
    @Published var loading = false
    @Published var showAlert: Bool = false
    
    var resetOTP: (() async -> Void)?
    var confirmOTP: ((String) async -> (Bool, String?))?
    
    weak var delegate: OtpModelDelegate?
    
    private var maxCounterValue: Double = 120
    private var counterValue: Double = 0
    private var timer: Timer?
    
    init(title: String = "confirm_otp".localize, number: String, countryCode: String, maxCounterValue: Double = 120) {
        self.title = title
        self.number = number
        self.countryCode = countryCode
        self.maxCounterValue = maxCounterValue
    }
    
    func onTypingOtp() {
        isValidForm = otp.count > 3
    }
    
    func onAppear() {
        startCounter()
    }
    
    private func startCounter() {
        resetCounter()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onDownCounting), userInfo: nil, repeats: true)
    }
    
    private func resetCounter() {
        counterValue = maxCounterValue
        reloadCounterValue()
        invalidateTimer()
        shouldResend = false
    }
    
    private func reloadCounterValue() {
        counter = Date.formattedSeconds(counterValue, false)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func onDownCounting() {
        counterValue -= 1
        
        if counterValue <= 0 {
            invalidateTimer()
            shouldResend = true
        }
        
        reloadCounterValue()
    }
    
    func requestForOTP() {
        resetCounter()
        showLoader()
        
        defer {
            self.hideLoader()
        }
        Task {
            if let resetOTP {
                await resetOTP()
            } else {
                let _ = await UserNetworkService.shared.getOTP(forNumber: self.number)
            }
            
            await MainActor.run {
                self.startCounter()
            }
        }
    }
    
    func onClickConfirm() {
            
        self.showLoader()
        Task {
            if let confirmOTP {
                let result = await confirmOTP(self.otp)
                
                await MainActor.run(body: {
                    self.onResultConfirm(result.0, result.1)
                })
            } else {
                let result = await UserNetworkService.shared.confirm(otp: self.otp)
                
                await MainActor.run(body: {
                    self.onResultConfirm(result, nil)
                })
            }
        }
    }
    
    private func onResultConfirm(_ result: Bool, _ error: String?) {
        self.hideLoader()
        self.otpErrorMessage = result ? "" : (error ?? "not_valid_otp".localize)
        self.delegate?.otp(model: self, isSuccess: result)
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            self.loading = true
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.loading = false
        }
    }
}
