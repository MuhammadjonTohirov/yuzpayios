//
//  OtpViewModel.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

protocol OtpModelDelegate: NSObject {
    func otp(model: OtpViewModel, isSuccess: Bool)
}

final class OtpViewModel: ObservableObject {
    var title: String = "confirm_otp".localize
    var number: String = "+998 93 585-24-15"
    @Published var otp: String = ""
    @Published var isValidForm = false
    @Published var counter: String = ""
    @Published var shouldResend = false
    @Published var otpErrorMessage = ""
    weak var delegate: OtpModelDelegate?
    private var maxCounterValue: Double = 5
    private var counterValue: Double = 0
    private var timer: Timer?
    
    init(title: String = "confirm_otp".localize, number: String = "+998 93 585-24-15", maxCounterValue: Double = 5) {
        self.title = title
        self.number = number
        self.maxCounterValue = maxCounterValue
    }
    
    func onTypingOtp() {
        isValidForm = otp.count > 3
    }
    
    func startCounter() {
        resetCounter()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onDownCounting), userInfo: nil, repeats: true)
    }
    
    func resetCounter() {
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
    
    func onClickConfirm() {
        let isConfirmed = otp == "123123"
        otpErrorMessage = isConfirmed ? "" : "not_valid_otp".localize
        
        delegate?.otp(model: self, isSuccess: isConfirmed)
    }
}
