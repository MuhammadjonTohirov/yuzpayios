//
//  OtpViewModel.swift
//  YuzPay
//
//  Created by applebro on 11/12/22.
//

import Foundation

final class OtpViewModel: ObservableObject {
    @Published var otp: String = ""
    @Published var isValidForm = false
    @Published var counter: String = ""
    @Published var shouldResend = false
    private var maxCounterDouble: Double = 5
    private var counterValue: Double = 0
    private var timer: Timer?
    
    func onTypingOtp() {
        isValidForm = otp.count > 3
    }
    
    func startCounter() {
        resetCounter()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onDownCounting), userInfo: nil, repeats: true)
    }
    
    func resetCounter() {
        counterValue = maxCounterDouble
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
}
